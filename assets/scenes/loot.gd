extends Node2D

onready var root = get_tree().get_current_scene()
onready var player = root.find_node('player')
onready var animation = get_node('AnimatedSprite')
var drop_type = ''
var amount

func _ready():
	pass # Replace with function body.

func get_type(type):
	return drop_type

func set_type(type, amount):
	self.drop_type = type
	self.animation.play(type)
	self.amount = amount

func _on_Area2D_body_entered(body):
	if body.name == 'player':
		# play pickup sound based on type
		if self.drop_type == 'gold':
			player.add_gold(self.amount)
		elif self.drop_type == 'potion':
			player.heal(30)
		queue_free()
