extends KinematicBody2D

# Declare member variables here. Examples:
onready var root = get_tree().get_current_scene()
onready var player = root.find_node('player')
onready var attack_timer = get_node('attack_timer')
onready var hit_anim = get_node('hit')
onready var collider = get_node('CollisionShape2D')
export(int) var speed = 150
export(int) var health = 20
var velocity = null
var dist_to_player = -1
var dead = false
const type = 'MONSTER'

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	# Basic movement
	if not dead:
		look_at(player.get_global_position())
		velocity = Vector2(speed, 0).rotated(rotation)
		velocity = move_and_slide(velocity)
		# Keep track of distance to player
		self.dist_to_player = self.get_global_position().distance_to(player.get_global_position())
		# Attacking
		if self.dist_to_player <= 50:
			attack()
		else:
			attack_timer.stop()
	# Ded
	if health <= 0:
		self.dead = true
		self.collider.disabled = true
		self.z_index = 1
		if hit_anim.is_playing() == false:
			queue_free()

func get_dist_to_player():
	return self.dist_to_player

func attack():
	if (attack_timer.is_stopped() or attack_timer.time_left <= 0.1) and not self.dead:
		print(name+' attacks!')
		attack_timer.start(1.5)
		player.hurt(5)

func is_dead():
	return dead

func hurt(source):
	if not dead:
		self.health = health - source.damage
		hit_anim.play('magic')
