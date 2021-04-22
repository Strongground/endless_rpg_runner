extends Node2D

onready var root = get_tree().get_current_scene()
onready var player = root.find_node('player')
onready var chunkManager = root.find_node('chunkManager')
onready var spawn_area = root.find_node('monster_spawn_area')
var monster_list = []

func _ready ():
	pass

func spawn_monsters(amount):
	var player_position = player.get_global_position().floor()
	var monster_class = load("res://assets/scenes/monster.tscn")
	var viewport = get_viewport().get_visible_rect().size
	randomize()
	for _i in range(amount):
		var monster_instance = monster_class.instance()
		print(str(viewport.x)+'-('+str(viewport.x/2)+')+'+str(player_position.x))
		var x_pos = randi() % int(viewport.x) - int(viewport.x/2) + int(player_position.x)
		var y_pos = randi() % int(viewport.y) - int(viewport.y/2) + int(player_position.y)
		root.add_child(monster_instance, true)
		monster_instance.set_global_position(Vector2(x_pos, y_pos))
		monster_list.append(monster_instance)

func get_nearest_monster_to_player():
	var nearest_monster = null
	for monster in monster_list:
		if not monster.is_dead():
			if nearest_monster == null:
				nearest_monster = monster
			# get_dist_to_player() returns -1 if monster didn't yet update distance. In this case, skip the monster for now.
			elif monster.get_dist_to_player() > 0 && monster.get_dist_to_player() < nearest_monster.get_dist_to_player():
				nearest_monster = monster
	return nearest_monster
