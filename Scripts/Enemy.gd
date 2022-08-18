extends KinematicBody2D

const MOVE_SPEED = 10

var velocity = Vector2()
var move_direction = -1

func _physics_process(delta):
	velocity.x = MOVE_SPEED * move_direction

	velocity = move_and_slide(velocity, Vector2.UP)