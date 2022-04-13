extends RigidBody2D
export var speed := 400
export var angle := 20
export var launch_angle := 180

var Egg = preload("res://Enemy Scenes/Egg.tscn")
var time_start = OS.get_unix_time()


func get_input():
	# Add these actions in Project Settings -> Input Map.
	#velocity = Vector2(speed, 0).rotated(rotation)
	#if Input.is_action_just_pressed('click'):
		#print(get_viewport().get_mouse_position());
		#shoot()
/	var dist = get_tree().get_nodes_in_group("Player")[0].global_position - $Muzzle.global_position
	var angle_distance = fmod(rad2deg(dist.angle()) + 180 - rad2deg(rotation),360)
	if($AnimatedSprite.animation == "shoot" and OS.get_unix_time() - time_start > .8):
		$AnimatedSprite.animation = "idle"
	if(OS.get_unix_time() - time_start > 1 and (angle_distance < angle or angle_distance > 360 - angle)):
		$AnimatedSprite.animation = "shoot"
		time_start = OS.get_unix_time()
		shoot()

func shoot():
	# "Muzzle" is a Position2D placed at the barrel of the gun.
#	var b = Egg.instance()
#	b.start($Muzzle.position, rotation)
#	add_child(b)

	var b = Egg.instance()
	get_tree().get_root().add_child(b)
	b.start($Muzzle.position + self.position, launch_angle)

	print(get_tree().get_root())

func _physics_process(delta):
	get_input()
