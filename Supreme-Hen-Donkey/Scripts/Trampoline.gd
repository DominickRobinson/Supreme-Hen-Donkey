extends Node2D

export var impulse_no_jump: float
export var impulse_jump: float

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

		body.apply_central_impulse(Vector2(imp * sin(rotation_degrees), imp * cos(rotation_degrees)))
		anim.animation = "Boing"



func _on_AnimatedSprite_animation_finished():
	anim.animation = "Idle"
