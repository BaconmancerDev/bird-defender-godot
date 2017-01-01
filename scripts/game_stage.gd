# script: game_stage

extends Node

var Enemy = preload("res://scenes/enemy.tscn")

onready var timer = get_node("timer")
onready var tree = get_node("tree")
onready var level_label = get_node("level")

var new_enemy
var game_over = false
var level = 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	new_enemy = Enemy.instance()
	new_enemy.connect("enemy_destroyed", self, "advance_level")
	add_child(new_enemy)
	tree.connect("tree_destroyed", self, "game_over")
	timer.connect("timeout", self, "restart")
	level_label.set_text("LEVEL: " + str(level))
	pass

func game_over():
	game_over = true
	level_label.set_text("GAME OVER")
	timer.start()
	pass

func create_enemy():
	new_enemy = Enemy.instance()
	
	new_enemy.connect("enemy_destroyed", self, "advance_level")
	
	var min_redux = new_enemy.min_wait_time * (level * 0.25)
	if min_redux <= 0:
		min_redux = 0
	new_enemy.min_wait_time -= min_redux
	
	var max_redux = new_enemy.max_wait_time * (level * 0.25)
	if max_redux <= 0:
		max_redux = 0
	new_enemy.max_wait_time -= max_redux
	
	var enemy_speed_increase = new_enemy.speed * (level * 0.25)
	new_enemy.speed += enemy_speed_increase
	
	var blade_speed_increase = new_enemy.speed * (level * 0.25)
	new_enemy.blade_speed += blade_speed_increase 
	
	new_enemy.health += level
	
	pass

func advance_level():
	level += 1
	level_label.set_text("LEVEL: " + str(level))
	create_enemy()
	timer.start()
	pass

func restart():
	if game_over:
		get_tree().reload_current_scene()
	else:
		add_child(new_enemy)
	pass