extends RigidBody2D

#export var SIGHT_RADIUS := 200
export var FLIGHT_SPEED := 200

onready var bottom_zone = $BottomZone

var attack_mode = false

var enabled := true
onready var dragCollider = $CollisionShape2D

func _ready():
	pass # Replace with function body.


func _process(delta):
	if not enabled:
		return
	
	check_for_player()
		
	if attack_mode:
		
		$AnimatedSprite.animation = "Flying"
		$AnimatedSprite.speed_scale = 3
	
	else:
		
		$AnimatedSprite.speed_scale = 1
		
		if is_on_floor():
			$AnimatedSprite.animation = "Idle"
		else:
			$AnimatedSprite.animation = "Flying"
	
	
	if linear_velocity.x > 0:
		$AnimatedSprite.flip_h = true
	elif linear_velocity.x < 0:
		$AnimatedSprite.flip_h = false
		
		
		
func is_on_floor(): 
	return false
	#return !bottom_zone.get_overlapping_bodies().empty()

#func _integrate_forces(state):
#	rotation = 0


func check_for_player():
	
	var player_found = false
	
	for body in $SightZone.get_overlapping_bodies():
		
		if body is Player:
			
				player_found = true
			
				attack_mode = true
			
				var dist = (body.position - self.position).normalized()
				
				linear_velocity = dist * FLIGHT_SPEED
				
	if not player_found:
		attack_mode = false
		linear_velocity *= 0.99
