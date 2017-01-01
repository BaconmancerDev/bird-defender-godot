# script: enemy

extends Area2D

var Blade = preload("res://scenes/blade.tscn")

onready var timer = get_node("timer") 
onready var emitter = get_node("emitter")
onready var health_label = get_node("health")

signal enemy_destroyed

var min_wait_time = 1
var max_wait_time = 3
var speed = -100
var health = 1
var blade_speed = -200

func _ready():
	set_pos(Vector2(624, 240))
	health_label.set_text("H:\n" + str(health))
	timer.connect("timeout", self, "shoot")
	connect("body_enter", self, "take_dmg")
	timer.set_wait_time(rand_range(min_wait_time,max_wait_time))
	timer.start()
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	move(delta)
	pass

func move(delta):
	var new_y = get_pos().y + speed * delta
	
	if speed < 0 and new_y <= 48:
		new_y = 48
		speed *= -1
	elif speed > 0 and new_y >= 432:
		new_y = 432
		speed *= -1
		
	set_pos(Vector2(get_pos().x, new_y))
	pass
	
func shoot():
	var new_blade = Blade.instance()
	new_blade.set_pos(get_pos())
	new_blade.vx = blade_speed
	get_node("..").add_child(new_blade)
	randomize()
	timer.set_wait_time(rand_range(1,3))
	pass

func take_dmg(body):
	health -= 1
	health_label.set_text("H:\n" + str(health))
	emitter.set_emitting(true)
	if health <= 0:
		emit_signal("enemy_destroyed")
		queue_free()
	body.queue_free()
	pass