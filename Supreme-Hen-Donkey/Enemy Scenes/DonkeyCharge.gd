extends RigidBody2D

export var CHARGE_SPEED := 400


var attack_mode = false

var enabled := true
onready var dragCollider = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	
	check_for_player()


	if attack_mode:
		$AnimatedSprite.animation = "Charging"
		$AnimatedSprite.speed_scale = 2
	else:
		$AnimatedSprite.animation = "Idle"
		$AnimatedSprite.speed_scale = 1
		
	
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
			
				var dist = body.position.x - self.position.x
				
				linear_velocity.x = sign(dist) * CHARGE_SPEED
				
	if not player_found:
		attack_mode = false
		linear_velocity *= 0.99


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
