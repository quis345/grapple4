extends Node

const team_colors = [Color(1, 0.5,0), Color(0, 0.5, 1)]

#var regen : Node
var main: Node2D
var color : Color = Color(0,0,0)
var ball : RigidBody2D
var scoreboard : RichTextLabel
var scores := [0, 0]
var players = []
var countdown: float = -1.0

# big game changes
const SCALE = 2.0
const GRAVITY: bool = true
const SOCCAR_MODE: bool = false
const PADDLE_BALL: bool = true
var time := 180.0

	#soccar settings:
const hit_buffer := 30
const hit_power := 5.0
const NEAR_DAMP := 1.5
const DAMP_FALLOFF := 0.3
const BASE_DAMP := 0.00
const KICK_DELAY := 1.0

var max_time := 180.0
var winner = ""
var active := false

var ball_speed: int = 0

func reset():
	yield(get_tree().create_timer(0.0001), "timeout")
	winner = ""
	active = false
	time = max_time
	countdown = 5.0

func _ready():
	var max_time = time
	countdown = 5.0
#	for player in players:
#		player.disabled = true
	yield(get_tree().create_timer(0.001), "timeout")

func _process(delta):
	if time <= 0:
		time = 0
		ball.disable = true
		for player in players: player[1].disabled = true
		if scores[0] > scores[1]:
			winner = "[center][color=#"+ str(team_colors[1].to_html()) +"]Blue Wins!"
			main.get_node("transitionout").modulate = team_colors[1].to_html()
		elif scores[1] > scores[0]:
			winner = "[center][color=#"+ str(team_colors[0].to_html()) +"]Orange Wins!"
			main.get_node("transitionout").modulate = team_colors[0].to_html()
		else:
			winner = "[center]DRAW!\nthis really should have a match point system but i havnt programed that yet lol"
			
		main.get_node("transitionout").emitting = true
		yield(get_tree().create_timer(3.0), "timeout")
		players = []	
		scores = [0, 0]
		get_tree().reload_current_scene()
		reset()
	
	if countdown <= 0 and countdown > -1:
		countdown = -1
		for player in players:
			player[1].disabled = false
		if GRAVITY:
			ball.gravity_scale = 9.8/SCALE
			ball.apply_impulse(Vector2.ZERO, Vector2(0, -1.2/pow(SCALE, 0.5)))
		active = true
	elif countdown > -1: 
		active = false
		countdown -= delta
		for player in players:
			if is_instance_valid(player[1]):
				player[1].disabled = true
		ball.gravity_scale = 0
		if GRAVITY:
			ball.position = Vector2(1920, 1620)
		else:
			ball.position = Vector2(1920, 1080)
		ball.linear_velocity = Vector2.ZERO
	if active: time -= delta

var pause = false
func _input(event):
	if event.is_action_pressed("debug"):
		if not pause: Engine.time_scale = 0
		else: Engine.time_scale = 1
		pause = not pause
	
