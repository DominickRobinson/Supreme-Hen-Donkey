extends KinematicBody2D

var Egg = preload("res://Egg.tscn")
var speed = 200
var time_start = OS.get_unix_time()

func get_input():
	# Add these actions in Project Settings -> Input Map.
	#velocity = Vector2(speed, 0).rotated(rotation)
	#if Input.is_action_just_pressed('click'):
		#print(get_viewport().get_mouse_position());
		#shoot()
	var dist = get_tree().get_nodes_in_group("Player")[0].global_position - $Muzzle.global_position
	var angle_distance = fmod(rad2deg(dist.angle())+180 - rad2deg(rotation),360)
	var freedom = 20
	if($AnimatedSprite.animation == "shoot" and OS.get_unix_time() - time_start > .8):
		$AnimatedSprite.animation = "idle"
	if(OS.get_unix_time() - time_start > 1 and (angle_distance < freedom or angle_distance > 360 - freedom)):
		$AnimatedSprite.animation = "shoot"
		time_start = OS.get_unix_time()
		shoot()

func shoot():
	# "Muzzle" is a Position2D placed at the barrel of the gun.
	var b = Egg.instance()
	b.start($Muzzle.position, rotation)
	add_child(b)

func _physics_process(delta):
	get_input()
