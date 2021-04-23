extends RigidBody2D

onready var lifetime = get_node('lifetime')
onready var fade_timer = get_node('fade_timer')
onready var animation_player = get_node('AnimationPlayer')
onready var collider = get_node('CollisionShape2D')
var colliding_bodies
var target
var speed = 10
var damage_type = 'magic'
var damage = 10

func _ready():
	lifetime.start(5)

func set_target(target_coords):
	self.target = target_coords
	self.add_force(Vector2(0,0), (target-self.get_global_position()).normalized()*speed)

func _physics_process(delta):
	# Collision detection
	colliding_bodies = self.get_colliding_bodies()
	if len(colliding_bodies) > 0:
		for body in colliding_bodies:
			if body.type == 'MONSTER':
				body.hurt(self)

func _decay():
	lifetime.stop()
	var animation_length = animation_player.get_animation('fade_away').get_length()
	animation_player.play('fade_away')
	fade_timer.start(animation_length)

func _kill():
	queue_free()
