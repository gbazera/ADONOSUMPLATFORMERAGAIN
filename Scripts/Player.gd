extends KinematicBody2D
class_name Player

const MOVE_SPEED = 31
const JUMP_FORCE = 140
const GRAVITY = 500

var velocity = Vector2()
var move_direction = 0
var look_direction = 1
var can_move = true
var blast_point = 0

var tile_pos = Vector2()
var tile_pos_map = Vector2()

onready var sprite = $AnimatedSprite
onready var blast_timer = $BlastTimer

onready var ground_tilemap = get_tree().root.get_child(0).get_child(2)

func _physics_process(delta):
	apply_gravity(delta)
	get_input()
	handle_movement()

	tile_pos = global_position + (Vector2(16, 0) * look_direction)
	tile_pos_map = ground_tilemap.world_to_map(tile_pos)

func apply_gravity(delta):
	velocity.y += GRAVITY * delta

func get_input():
	if can_move:
		move_direction = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left'))

func handle_movement():
	if can_move:
		velocity.x = move_direction * MOVE_SPEED
	else:
		velocity.x = 0

	velocity = move_and_slide(velocity, Vector2.UP)

	if Input.is_action_just_pressed('jump') and is_on_floor() and can_move:
		velocity.y -= JUMP_FORCE
	
	if blast_timer.is_stopped():
		can_move = true

		if is_on_floor():
			if velocity.x != 0:
				sprite.animation = 'run'
			else:
				sprite.animation = 'idle'
		else:
			sprite.animation = 'jump'
	else:
		can_move = false

		sprite.animation = 'blast'
	
	if move_direction > 0:
		sprite.flip_h = false
		look_direction = 1
	elif move_direction < 0:
		sprite.flip_h = true
		look_direction = -1

	if is_on_floor() and velocity.x == 0 and Input.is_action_just_pressed('blast') and blast_timer.is_stopped() and blast_point > 0:
		blast_timer.start()
		blast_point -= 1


func _on_BlastTimer_timeout():
	ground_tilemap.set_cellv(tile_pos_map, -1)
