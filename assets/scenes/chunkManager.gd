extends Node2D

export (int) var chunk_size = 2048
onready var root = get_tree().get_current_scene()
var active_chunk = null

func _ready():
	pass

func set_active (chunk):
	self.active_chunk = chunk
	_create_chunks()

func get_active_chunk():
	# return root.find_node(active_chunk)
	return self.active_chunk

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
	var half_chunk = chunk_size/2
	if typeof(origin) == 5:
		if direction == 'N':
			return Vector2(origin.x, origin.y-half_chunk)
		elif direction == 'NE':
			return Vector2(origin.x+half_chunk, origin.y-half_chunk)
		elif direction == 'E':
			return Vector2(origin.x+half_chunk, origin.y)
		elif direction == 'SE':
			return Vector2(origin.x+half_chunk, origin.y+half_chunk)
		elif direction == 'S':
			return Vector2(origin.x, origin.y+half_chunk)
		elif direction == 'SW':
			return Vector2(origin.x-half_chunk, origin.y+half_chunk)
		elif direction == 'W':
			return Vector2(origin.x-half_chunk, origin.y)
		elif direction == 'NW':
			return Vector2(origin.x-half_chunk, origin.y-half_chunk)

func _create_chunks():
	var chunk_class = preload("res://assets/scenes/chunk.tscn")
	# Check which neighbouring chunks are not registered (= don't exist)
	var missing_neighbours = self._get_missing_neighbours(self.get_active_chunk())
	var all_created_neighbours = {}
	# If at least one neighbour doesn't exist...
	if missing_neighbours.size() > 0:
		var origin = self.get_active_chunk().get_global_transform().origin
		for direction in missing_neighbours:
			var chunk_instance = chunk_class.instance()
			var new_chunk_pos = self._get_relative_coords(origin, direction)
			chunk_instance.set_global_position(new_chunk_pos)
			# Set active origin chunk as neighbour for each new created chunk
			self.get_active_chunk().set_neighbour(direction, chunk_instance)
			# Add this new created chunk to a list of created chunks during this run
			all_created_neighbours[direction] = chunk_instance
			root.add_child(chunk_instance, true)
	# Based on the list of created chunks, add all to each other as neighbour so we don't
	# attempt to create them again next time.
	self._set_relative_neighbours(all_created_neighbours)

# Class method to determine which neighbouring chunks are missing from the given one.
# @input (Object@chunk.gd) chunk: The chunk whose neighbours should be checked
# @return (Array) An array containing all directions (each a String) that have no chunk registered.
func _get_missing_neighbours(chunk):
	var missing_neighbours = []
	for neighbour in chunk.neighbours:
		if chunk.neighbours[neighbour] == null:
			missing_neighbours.append(neighbour)
	return missing_neighbours

func _set_relative_neighbours(created_chunks):
	for direction in created_chunks:
		var chunk = created_chunks[direction]
		var rel_direction = self._get_direction_from_origin(chunk)
		if rel_direction == 'N':
			chunk.set_neighbour('S', get_active_chunk())
			chunk.set_neighbour('SE', get_active_chunk().neighbours.get('NE'))
			chunk.set_neighbour('SW', get_active_chunk().neighbours.get('NW'))
			chunk.set_neighbour('E', get_active_chunk().neighbours.get('NE'))
			chunk.set_neighbour('W', get_active_chunk().neighbours.get('NW'))
		elif rel_direction == 'NE':
			chunk.set_neighbour('SW', get_active_chunk())
			chunk.set_neighbour('W', get_active_chunk().neighbours.get('N'))
			chunk.set_neighbour('S', get_active_chunk().neighbours.get('E'))
		elif rel_direction == 'E':
			chunk.set_neighbour('W', get_active_chunk())
			chunk.set_neighbour('NW', get_active_chunk().neighbours.get('N'))
			chunk.set_neighbour('SE', get_active_chunk().neighbours.get('S'))
			chunk.set_neighbour('N', get_active_chunk().neighbours.get('NE'))
			chunk.set_neighbour('S', get_active_chunk().neighbours.get('SE'))
		elif rel_direction == 'SE':
			chunk.set_neighbour('NW', get_active_chunk())
			chunk.set_neighbour('N', get_active_chunk().neighbours.get('E'))
			chunk.set_neighbour('W', get_active_chunk().neighbours.get('S'))
		elif rel_direction == 'S':
			chunk.set_neighbour('N', get_active_chunk())
			chunk.set_neighbour('NW', get_active_chunk().neighbours.get('W'))
			chunk.set_neighbour('NE', get_active_chunk().neighbours.get('E'))
			chunk.set_neighbour('E', get_active_chunk().neighbours.get('SE'))
			chunk.set_neighbour('W', get_active_chunk().neighbours.get('SW'))
		elif rel_direction == 'SW':
			chunk.set_neighbour('NE', get_active_chunk())
			chunk.set_neighbour('E', get_active_chunk().neighbours.get('W'))
			chunk.set_neighbour('N', get_active_chunk().neighbours.get('S'))
		elif rel_direction == 'W':
			chunk.set_neighbour('E', get_active_chunk())
			chunk.set_neighbour('NE', get_active_chunk().neighbours.get('N'))
			chunk.set_neighbour('SE', get_active_chunk().neighbours.get('S'))
			chunk.set_neighbour('N', get_active_chunk().neighbours.get('NW'))
			chunk.set_neighbour('S', get_active_chunk().neighbours.get('SW'))
		elif rel_direction == 'NW':
			chunk.set_neighbour('SE', get_active_chunk())
			chunk.set_neighbour('E', get_active_chunk().neighbours.get('N'))
			chunk.set_neighbour('S', get_active_chunk().neighbours.get('W'))
	
# Relative to the origin chunk, get the direction another chunk is
func _get_direction_from_origin(chunk):
	for direction in self.get_active_chunk().neighbours:
		if self.get_active_chunk().neighbours.get(direction) == chunk:
			return direction

func _draw_marker(target_coords):
	var marker_class = load("res://assets/scenes/marker.tscn")
	var marker_instance = marker_class.instance()
	marker_instance.set_global_position(target_coords)
	root.add_child(marker_instance, true)
