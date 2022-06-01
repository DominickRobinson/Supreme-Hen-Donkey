extends Node2D

export var impulse_no_jump := 1000
export var impulse_jump := 1500

onready var anim = $AnimatedSprite

var enabled := true
onready var dragCollider = $Base/CollisionPolygon2D


func _on_BounceArea_body_entered(body):
	if body is Player:
		var imp
		if Input.is_action_pressed("jump"):
			imp = impulse_jump			
		else:
			imp = impulse_no_jump

		var deg = deg2rad(90 - rotation_degrees)
		#body.apply_central_impulse(Vector2(imp * sin(rotation_degrees), imp * cos(rotation_degrees)))
		var vec = Vector2(cos(deg), -sin(deg))
		#print(imp * vec)
		#print("oof #" + str(Globals.oof_counter))
		Globals.oof_counter += 1
		body.linear_velocity = imp * vec 
		#body.linear_velocity.y = -body.linear_velocity.y
		#body.apply_central_impulse(imp * vec)
		anim.animation = "Boing"



func _on_AnimatedSprite_animation_finished():
	anim.animation = "Idle"
