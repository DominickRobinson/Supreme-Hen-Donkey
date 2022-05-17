extends RigidBody2D

#export var SIGHT_RADIUS := 200
export var FLIGHT_SPEED := 400
export var is_flipped := false

onready var bottom_zone = $BottomZone

var attack_mode = false

var enabled := true
onready var dragCollider = $CollisionShape2D

var pref_scale

func _ready():
	pref_scale = scale


func _integrate_forces(state):
	
	scale = pref_scale
	
	if is_flipped:
		#scale = Vector2(-1,1)
		scale.x *= -abs(scale.x)
		#setScale(-1,1)
		#$AnimatedSprite.flip_h = true
		#self.rotation_degrees = 180
		#$AnimatedSprite.rotation_degrees = 180
		#pass




func _process(delta):
	if not enabled:
		return
	
	check_for_player()
		
	if attack_mode:
		
		$AnimatedSprite.animation = "Flying"
		$AnimatedSprite.speed_scale = 3
		gravity_scale = 0
	
	else:
		
		gravity_scale = 20
		$AnimatedSprite.speed_scale = 1
		$AnimatedSprite.animation = "Idle"
		#$AnimatedSprite.animation = "Flying"
	
	if linear_velocity.x > 0:
		$AnimatedSprite.flip_h = true
	elif linear_velocity.x < 0:
		$AnimatedSprite.flip_h = false
		


func check_for_player():
	
	var player_found = false
	
	for body in $SightZone.get_overlapping_bodies():
		
		if body is Player:
			
				player_found = true
			
				attack_mode = true
			
				var dist = (body.global_position - self.global_position).normalized()
				
				#linear_velocity = dist * FLIGHT_SPEED
				#apply_central_impulse(dist * FLIGHT_SPEED)
				applied_force = dist * FLIGHT_SPEED
				
	if not player_found:
		attack_mode = false
		linear_velocity *= 0.99
		#applied_force = Vector2(0,0)
