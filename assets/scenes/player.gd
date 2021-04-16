extends KinematicBody2D

# Declare member variables here.
onready var root = get_tree().get_current_scene()
onready var camera = root.find_node("camera")
export(int) var speed = 200
var velocity = Vector2()

func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	# Basic movement
	self.look_at(get_global_mouse_position())
	velocity = Vector2(0,0)
	if Input.is_action_pressed("ui_run"):
		velocity = Vector2(speed, 0).rotated(rotation)
	velocity = move_and_slide(velocity)
