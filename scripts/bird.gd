# script: bird

extends Area2D

var Blade = preload("res://scenes/blade.tscn")
var Deflector = preload("res://scenes/deflector.tscn")

onready var anim = get_node("anim")
var deflector

var new_pos

var attack = false
var deflect = false

func _ready():
	deflector = Deflector.instance()
	add_child(deflector)
	set_fixed_process(true)
	pass
	
func _fixed_process(delta):
	process_input()
	check_collisions()
	move()
	pass
	
func move():
	new_pos = get_global_mouse_pos()
	
#	if new_pos.x <= 96:
#		new_pos.x = 96
#	elif new_pos.x >= 400:
#		new_pos.x = 400
	set_pos(new_pos)
	pass
	
func process_input():
	attack = false
	deflect = false
	
	if Input.is_action_pressed("attack"):
		attack()
	elif Input.is_action_pressed("deflect"):
		deflect()
	elif anim.get_current_animation() != "idle":
		anim.play("idle")
	pass

func attack():
	attack = true
	if anim.get_current_animation() != "attack":
		anim.play("attack")
	pass

func deflect():
	deflect = true
	pass

func check_collisions():
	var bodies
	
	if attack:
		bodies = get_overlapping_bodies()
		if bodies.size() != 0:
			for body in bodies:
				if body.has_method("stop"):
					body.stop()
	if deflect:
		bodies = deflector.get_overlapping_bodies()
		if bodies.size() != 0:
			for body in bodies:
				if body.has_method("deflect"):
					body.deflect()
	pass