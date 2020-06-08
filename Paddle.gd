extends KinematicBody2D

class_name Paddle

export (float) var MAX_POSITION := 540.0
export (float) var MIN_POSITION := 64.0

var velocity := Vector2.ZERO
var speed := 400.0

func change_velocity(new_velocity) -> void:
	velocity = new_velocity
	if velocity.length() > 0:
		set_process(true)
	else:
		set_process(false)

func _process(delta: float) -> void:
	var new_position = global_position + velocity.normalized()*speed*delta
	new_position.y = clamp(new_position.y,MIN_POSITION, MAX_POSITION)
	global_position = new_position
