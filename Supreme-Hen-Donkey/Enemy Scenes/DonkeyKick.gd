extends RigidBody2D

export var KICK_STRENGTH := 1000
export var KICK_ANGLE := 90

var attack_mode = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "Idle"



func _process(delta):
	
	check_for_player()

	if $AnimatedSprite.animation == "Kicking":
			
		if 14 <= $AnimatedSprite.frame and $AnimatedSprite.frame <= 21:
			
			for body in $KickZone.get_overlapping_bodies():
				
				if body is Player:
		
					body.linear_velocity.x = -cos(deg2rad(KICK_ANGLE + self.rotation_degrees)) * KICK_STRENGTH
					body.linear_velocity.y = -sin(deg2rad(KICK_ANGLE + self.rotation_degrees)) * KICK_STRENGTH
					
	#_on_AnimatedSprite_animation_finished()


				
func check_for_player():

	for body in $SightZone.get_overlapping_bodies():

		if body is Player:

			$AnimatedSprite.animation = "Kicking"



func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.animation = "Idle"
