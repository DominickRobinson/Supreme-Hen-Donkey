
extends RigidBody2D
export var interval := 2
export var shoot_speed := 2000
export var max_enemies := 50

var Chicken = preload("res://Enemy Scenes/Chicken.tscn")
var DonkeyKick = preload("res://Enemy Scenes/DonkeyKick.tscn")
var DonkeyCharge = preload("res://Enemy Scenes/DonkeyCharge.tscn")
var HenFly = preload("res://Enemy Scenes/HenFly.tscn")
#differences are probability each will be spawned in order
var sprites = [Chicken,DonkeyKick,DonkeyCharge,HenFly]
var probdistribution = [.25,.5,.75,1.0]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enemy_count = 0
var at_once = 3

var shot = 0

var enabled = true
onready var dragCollider = $CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicController.play_music(3)
	pass # Replace with function body.

var time_start = OS.get_unix_time()

var rng = RandomNumberGenerator.new()
func shoot(linear_velocity):
	
	print("Enemy count: " + str(enemy_count))
	
	if enemy_count > max_enemies:
		return
	
	enemy_count += 1
		
		
	# "Muzzle" is a Position2D placed at the barrel of the gun.
	rng.randomize()
	var rand = rng.randf_range(0.0, 1.0)
	for i in range(0,probdistribution.size()):
		if rand < probdistribution[i]:
			var b = sprites[i].instance()
			b.position = $Muzzle.position+self.position
			#b.apply_central_impulse(linear_velocity)
			#get_tree().get_root().add_child(b)
			get_parent().add_child(b)
			break

func _physics_process(delta):
	if !enabled:
		return
	
	if(OS.get_unix_time() - time_start > interval):
		$AnimatedSprite.animation = "shoot"
		time_start = OS.get_unix_time()
		shot = 0
		#print(rad2deg(rotation))
	
	if $AnimatedSprite.animation == "shoot" and $AnimatedSprite.frame == 3 and shot < at_once:
		shoot(shoot_speed*Vector2(-1*cos(rotation),-1*sin(rotation)))
		shot += 1
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.animation = "idle"
