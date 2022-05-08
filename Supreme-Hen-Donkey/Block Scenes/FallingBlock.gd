extends Node2D

onready var anim = $AnimatedSprite

var enabled := true
onready var dragCollider = $Body/CollisionShape2D

func _on_Area2D_body_entered(body):
	if body is Player and enabled:
		anim.animation = "Falling"
		anim.play()


func _on_AnimatedSprite_animation_finished():
	$Body/CollisionShape2D.disabled = true
	$AnimatedSprite.visible = false # Replace with function body.
