extends Node2D

onready var root = get_tree().get_current_scene()
onready var player = root.find_node('player')
onready var chunkManager = root.find_node('chunkManager')
var monster_list = []

func _ready ():
	pass

func spawn_monsters(amount):
	var player_position = player.get_global_position()
	var monster_class = load("res://assets/scenes/monster.tscn")
	randomize()
	for _i in range(amount):
		var monster_instance = monster_class.instance()
		var x_pos = randi() % 5120 - (5120/2560) + player_position.x
		var y_pos = randi() % 5120 - (5120/2560) + player_position.y
		root.add_child(monster_instance, true)
		monster_instance.set_global_position(Vector2(x_pos, y_pos))
		monster_list.append(monster_instance)

func get_nearest_monster_to_player():
	var nearest_monster = null
	for monster in monster_list:
		if not monster.is_dead():
			if nearest_monster == null:
				nearest_monster = monster
			# get_dist_to_player returns -1 if monster didn't yet update distance
			elif monster.get_dist_to_player() > 0 && monster.get_dist_to_player() < nearest_monster.get_dist_to_player():
				nearest_monster = monster
	return nearest_monster
