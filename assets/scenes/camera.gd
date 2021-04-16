extends Camera2D

onready var root = get_tree().get_current_scene()
onready var player = root.find_node('player')

func _ready():
	pass

func _process(delta):
	# Update camera position
	self.set_global_transform(player.get_transform())
