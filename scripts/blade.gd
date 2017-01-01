# script: blade

extends KinematicBody2D

onready var anim = get_node("anim")

var vx = -500

var gravity = 10
var vy = 0

var stopped = false
var deflected = false

func _ready():
	set_fixed_process(true)
	anim.play("attacking")
	pass

func _fixed_process(delta):
	move(delta)
	if (get_pos().x < -32 or get_pos().x > 692 or get_pos().y > 512):
		queue_free()
	pass
	
func move(delta):
	var new_x = get_pos().x+ vx * delta
	var new_y = get_pos().y
	
	if stopped:
		vy += gravity
		new_y += vy * delta
	
	set_pos(Vector2(new_x, new_y))
	pass

func stop():
	stopped = true
	vx = 0
	vy = -300
	set_layer_mask_bit(1, false)
	set_layer_mask_bit(3, true)
	set_collision_mask_bit(2, true)
	anim.play("stopped")
	pass

func deflect():
	stopped = false
	deflected = true
	vx = 500
	set_layer_mask_bit(3, false)
	set_layer_mask_bit(4, true)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(2, false)
	set_collision_mask_bit(5, true)
	anim.play("deflected")