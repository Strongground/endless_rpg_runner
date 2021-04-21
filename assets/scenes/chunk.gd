extends Area2D

onready var root = get_tree().get_current_scene()
onready var player = root.find_node('player')
onready var monsterManager = root.find_node('monsterManager')
onready var chunkManager = root.find_node('chunkManager')
# onready var chunk_pos_output = root.find_node('chunk_pos_value')
# onready var player_pos_output = root.find_node('player_pos_value')
var isVisible = false
var isActive = false

func _ready():
	pass

func _process(delta):
	# player_pos_output.set_text(str(player.get_global_transform().get_origin()))
	# chunk_pos_output.set_text(str(self.get_global_transform()))
	pass

func _on_chunk_body_shape_entered(body_id, body, body_shape, local_shape):
	if not self.isActive:
		var entered_body_name = instance_from_id(body_id).name
		if entered_body_name == 'player':
			self.isActive = true
			print('Hi! '+self.name+' is now active!')
			chunkManager.setActive(true, self)
			monsterManager.spawn_monsters(5)
	
func _on_chunk_body_shape_exited(body_id, body, body_shape, area_shape):
	if self.isActive:
		var entered_body_name = instance_from_id(body_id).name
		if entered_body_name == 'player':
			self.isActive = false
			print('Hi! '+self.name+' is no longer active. :(')
			chunkManager.setActive(false, self)
