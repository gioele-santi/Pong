extends KinematicBody2D
class_name Ball

export (float, 100.0, 600.0) var START_SPEED := 400.0
export (float, 50.0, 200.0) var SPEED_BUMP := 10.0
var SCREEN_CENTER := Vector2(512, 300)
var velocity := Vector2.ZERO
var speed := 0.01

var spawn_count := -1 #compensate starting 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	pass # Replace with function body.

func spawn() -> void:
	spawn_count += 1
	speed = START_SPEED
	set_physics_process(false)
	global_position = SCREEN_CENTER
	velocity = Vector2.RIGHT.rotated(randf())
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	#print("processing, velocity %s position %s" % [velocity, position])
	#velocity = move_and_slide(velocity.normalized()*speed)
	var collision = move_and_collide(velocity.normalized() * speed * delta, false)
	if collision:
		$AudioStreamPlayer2D.play()
		speed += SPEED_BUMP
		velocity = velocity.bounce(collision.normal)
