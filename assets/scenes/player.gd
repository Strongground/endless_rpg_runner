extends KinematicBody2D

# Declare member variables here.
onready var root = get_tree().get_current_scene()
onready var camera = root.find_node("camera")
onready var monsterManager = root.find_node("monsterManager")
onready var health_value = camera.get_node('health_value')
onready var attack_cooldown = get_node('attack_cooldown')
onready var animation_player = get_node('AnimationPlayer')
export(int) var speed = 200
export(int) var health = 100
export(int) var attack_cooldown_time = 2
var level = 1
var velocity = Vector2()

func _ready():
	attack_cooldown.start(attack_cooldown_time)

func _physics_process(delta):
	# Basic movement
	self.look_at(get_global_mouse_position())
	velocity = Vector2(0,0)
	if Input.is_action_pressed("ui_run") and self.health > 0:
		velocity = Vector2(speed, 0).rotated(rotation)
	velocity = move_and_slide(velocity)
	# Health display
	health_value.set_text(str(self.health))
	health_value.set_rotation(camera.get_rotation())
	# Ded
	if self.health <= 0:
		self.hide()
	# Auto attack
	if attack_cooldown.time_left <= 0.1:
		var nearestMonster = monsterManager.get_nearest_monster_to_player()
		if nearestMonster != null && nearestMonster.get_dist_to_player() < 600:
			attack(monsterManager.get_nearest_monster_to_player())
			attack_cooldown.start(attack_cooldown_time)

func attack(target):
	var target_coords = target.get_global_position()
	var projectile_class = load("res://assets/scenes/projectile.tscn")
	var projectile_instance = projectile_class.instance()
	projectile_instance.set_global_position(self.get_global_position())
	projectile_instance.set_target(target_coords)
	root.add_child(projectile_instance, true)

func hurt(amount):
	animation_player.play('flash_hit')
	self.health = self.health-amount
