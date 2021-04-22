extends Node2D

export (int) var chunk_size = 512
onready var root = get_tree().get_current_scene()
var active_chunk = null

func _ready():
	pass

func set_active (chunk):
	self.active_chunk = chunk.name
	_create_chunks()

func get_active_chunk():
	return root.find_node(active_chunk)

func get_chunk_size():
	return self.chunk_size

# Class method
# Get coordinates for new chunk to place, relative to
# a given coordinate set. It is implied the given coordinates
# are that of another chunk.
# @input {Vector2} origin
# @input {String} direction Should be one of: N, NE, E, SE, S, SW, W, NW
func _get_relative_coords(origin, direction):
	# 5 is TYPE_VECTOR2
	if typeof(origin) == 5:
		if direction == 'N':
			return Vector2(origin.x, origin.y-chunk_size)
		elif direction == 'NE':
			return Vector2(origin.x+chunk_size, origin.y-chunk_size)
		elif direction == 'E':
			return Vector2(origin.x+chunk_size, origin.y)
		elif direction == 'SE':
			return Vector2(origin.x+chunk_size, origin.y+chunk_size)
		elif direction == 'S':
			return Vector2(origin.x, origin.y+chunk_size)
		elif direction == 'SW':
			return Vector2(origin.x-chunk_size, origin.y+chunk_size)
		elif direction == 'W':
			return Vector2(origin.x-chunk_size, origin.y)
		elif direction == 'NW':
			return Vector2(origin.x-chunk_size, origin.y-chunk_size)

func _create_chunks():
	if self.get_active_chunk().neighbours['N'] == null:
		var origin = self.get_active_chunk().get_global_transform().origin
		for direction in ['N','NE','E','SE','S','SW','W','NW']:
			var chunk_class = load("res://assets/scenes/chunk.tscn")
			var chunk_instance = chunk_class.instance()
			chunk_instance.set_global_position(self._get_relative_coords(origin, direction))
			self.get_active_chunk().set_neighbour(direction,chunk_instance)
			root.add_child(chunk_instance, true)

func _draw_marker(target_coords):
	var marker_class = load("res://assets/scenes/marker.tscn")
	var marker_instance = marker_class.instance()
	marker_instance.set_global_position(target_coords)
	root.add_child(marker_instance, true)
