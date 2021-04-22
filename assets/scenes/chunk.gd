extends Area2D

onready var root = get_tree().get_current_scene()
onready var player = root.find_node('player')
onready var monsterManager = root.find_node('monsterManager')
onready var chunkManager = root.find_node('chunkManager')
var is_visible = false
var is_active = false
var neighbours = {
	'N': null,
	'NE': null,
	'E': null,
	'SE': null,
	'S': null,
	'SW': null,
	'W': null,
	'NW': null
}

func _ready():
	pass

func _process(delta):
	pass

func _on_chunk_body_shape_entered(body_id, body, body_shape, local_shape):
	if not self.is_active:
		var entered_body_name = instance_from_id(body_id).name
		if entered_body_name == 'player':
			self.is_active = true
			print('Hi! '+self.name+' is now active!')
			chunkManager.set_active(self)
			monsterManager.spawn_monsters(0)
	
func _on_chunk_body_shape_exited(body_id, body, body_shape, area_shape):
	if self.is_active:
		var entered_body_name = instance_from_id(body_id).name
		if entered_body_name == 'player':
			self.is_active = false
			print('Hi! '+self.name+' is no longer active. :(')

func set_neighbour(direction, instance):
	if neighbours.has(direction):
		self.neighbours[direction] = instance
	else:
		print('Error: Direction '+str(direction)+' is invalid.')
