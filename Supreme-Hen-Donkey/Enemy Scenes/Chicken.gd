extends RigidBody2D
export var speed := 400
export var angle := 20
export var launch_angle := 0
export var is_flipped := false

var Egg = preload("res://Egg.tscn")
var time_start = OS.get_unix_time()

var enabled = true
#onready var dragCollider = $CollisionPolygon2D
onready var dragCollider = $CollisionShape2D

func _integrate_forces(state):
	if is_flipped:
		scale = Vector2(-1,1)
		#setScale(-1,1)
		#$AnimatedSprite.flip_h = true
		#self.rotation_degrees = 180
		#$AnimatedSprite.rotation_degrees = 180
		#pass

func get_input():
	# Add these actions in Project Settings -> Input Map.
	#velocity = Vector2(speed, 0).rotated(rotation)
	#if Input.is_action_just_pressed('click'):
		#print(get_viewport().get_mouse_position());
		#shoot()
		
	
#	var dist = get_tree().get_nodes_in_group("Player")[0].global_position - $Muzzle.global_position
#	var angle_distance = fmod(rad2deg(dist.angle())+180 - rad2deg(rotation),360)
#	if($AnimatedSprite.animation == "shoot" and OS.get_unix_time() - time_start > .8):
#		$AnimatedSprite.animation = "idle"
#	if(OS.get_unix_time() - time_start > 1 and (angle_distance < angle or angle_distance > 360 - angle)):
#		$AnimatedSprite.animation = "shoot"
#		time_start = OS.get_unix_time()
#		shoot()
	if ($AnimatedSprite.animation == "shoot" and OS.get_unix_time() - time_start > .8):
			$AnimatedSprite.animation = "idle"
			
	if (OS.get_unix_time() - time_start > 1):
		$AnimatedSprite.animation = "shoot"
		time_start = OS.get_unix_time()
		shoot()


func shoot():
	# "Muzzle" is a Position2D placed at the barrel of the gun.
	var b = Egg.instance()
	get_tree().get_root().add_child(b)
	b.start($Muzzle.global_position, launch_angle + self.rotation_degrees, speed)
	


func _physics_process(delta):
	if !enabled:
		return
	
	get_input()
