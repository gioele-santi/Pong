extends Node

signal left_movement(direction)
signal right_movement(direction)

onready var paddle_left : Paddle = $PaddleLeft
onready var paddle_right : Paddle = $PaddleRight
onready var ball : Ball = $Ball
onready var left_label := $HUD/Score/LeftPoints
onready var right_label := $HUD/Score/RightPoints

var winner := ""

export (int, 3, 99) var MAX_POINTS : = 3

var playing := false setget set_playing

var left_point := 0 setget set_left_point
var right_point := 0 setget set_right_point

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("left_movement", paddle_left, "change_velocity")
	connect("right_movement", paddle_right, "change_velocity")

func _unhandled_input(event: InputEvent) -> void:
	if not playing:
		if event.is_action_pressed("start_pause_game"):
			self.playing = true
		return
	
	if event.is_action_pressed("left_up"):
		emit_signal("left_movement", Vector2.UP)
	elif event.is_action_pressed("left_down"):
		emit_signal("left_movement", Vector2.DOWN)
	elif event.is_action_released("left_up") or event.is_action_released("left_down"):
		emit_signal("left_movement", Vector2.ZERO)
	elif event.is_action_pressed("right_up"):
		emit_signal("right_movement", Vector2.UP)
	elif event.is_action_pressed("right_down"):
		emit_signal("right_movement", Vector2.DOWN)
	elif event.is_action_released("right_up") or event.is_action_released("right_down"):
		emit_signal("right_movement", Vector2.ZERO)

func set_left_point(value: int) -> void:
	left_point = value
	left_label.text = str(left_point)
	if left_point >= MAX_POINTS:
		winner = "blue"
		self.playing = false

func set_right_point(value: int) -> void:
	right_point = value
	right_label.text = str(right_point)
	if right_point >= MAX_POINTS:
		winner = "red"
		self.playing = false

func set_playing(value: bool) -> void:
	playing = value
	$HUD/Score.visible = value
	$HUD/MessageBox.visible = !value
	ball.visible = value
	if playing:
		self.left_point = 0
		self.right_point = 0
		ball.spawn()
	else:
		$HUD/MessageBox/Title.text = ("The winner is %s\nHit SPACE to Play" % [winner]) 
		pass

func _on_LeftLimit_body_entered(body: Node) -> void:
	self.right_point += 1
	ball.spawn()

func _on_RightLimit_body_entered(body: Node) -> void:
	self.left_point += 1
	ball.spawn()
