extends Node2D

export var impulse_no_jump: float
export var impulse_jump: float

onready var anim = $AnimatedSprite

func _on_BounceArea_body_entered(body):
	if body is Player:
		if Input.is_action_pressed("jump"):
			body.apply_central_impulse(Vector2(0, impulse_jump))
		else:
			body.apply_central_impulse(Vector2(0, impulse_no_jump))
		anim.animation = "Boing"


func _on_AnimatedSprite_animation_finished():
	anim.animation = "Idle"
