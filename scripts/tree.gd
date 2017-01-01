# script: tree

extends Area2D

onready var emitter = get_node("emitter")
onready var health_label = get_node("health")
signal tree_destroyed
var health = 5

func _ready():
	health_label.set_text("HEALTH:\n" + str(health))
	connect("body_enter", self, "take_dmg")
	pass
	
func take_dmg(body):
	health -= 1
	health_label.set_text("HEALTH:\n" + str(health))
	emitter.set_pos(Vector2(64, body.get_pos().y))
	emitter.set_emitting(true)
	if health <= 0:
		emit_signal("tree_destroyed")
		queue_free()
	body.queue_free()
	pass
