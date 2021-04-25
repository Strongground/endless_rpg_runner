extends KinematicBody2D

# Declare member variables here.
onready var root = get_tree().get_current_scene()
onready var camera = root.find_node("camera")
onready var monsterManager = root.find_node("monsterManager")
onready var health_value = camera.get_node('health_value')
onready var gold_value = camera.get_node('gold_value')
onready var exp_value = camera.get_node('exp_value')
onready var level_value = camera.get_node('level_value')
onready var attack_cooldown = get_node('attack_cooldown')
onready var animation_player = get_node('AnimationPlayer')
export(int) var speed = 200
export(int) var health = 100
export(int) var attack_cooldown_time = 2
export(int) var gold = 0
export(int) var experience = 0
var level = 1.0
var velocity = Vector2()
var experience_factor = 1.8

func _ready():
	attack_cooldown.start(attack_cooldown_time)

func _physics_process(delta):
	# Basic movement
	self.look_at(get_global_mouse_position())
	velocity = Vector2(0,0)
	if Input.is_action_pressed("ui_run") and self.health > 0:
		velocity = Vector2(speed, 0).rotated(rotation)
	velocity = move_and_slide(velocity)
	# Player stats display
	health_value.set_text(str(self.health))
	gold_value.set_text(str(self.gold))
	exp_value.set_text(str(self.experience))
	level_value.set_text(str(self.level))
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

func add_gold(amount):
	self.gold = self.gold+amount

func heal(amount):
	if self.health + amount >= 100:
		self.health = 100
	else:
		self.health = health + amount

func add_exp(amount):
	var exp_necessary_for_next_level = float(self.level * 600) * experience_factor
	if self.experience + amount > exp_necessary_for_next_level:
		self.level = self.level + 1
	self.experience = self.experience + amount