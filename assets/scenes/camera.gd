extends Camera2D

onready var root = get_tree().get_current_scene()
onready var player = root.find_node('player')

func _ready():
	pass

func _physics_process(delta):
	self.set_global_position(player.get_global_position())

func print_viewport_rect():
	var visrect = get_viewport().get_visible_rect()
	print(visrect)

func _on_print_visrect_button_pressed():
	print_viewport_rect()
