extends Node2D

onready var anim = $AnimatedSprite

var enabled := true
onready var dragCollider = $Body/CollisionShape2D
export var break_mult := 1.0
export var break_automatic := false

func _ready():
	anim.speed_scale = break_mult
	if break_automatic == true:
		collapse()

func _on_Area2D_body_entered(body):
	if body is Player and enabled:
		collapse()


func _on_AnimatedSprite_animation_finished():
	$Body/CollisionShape2D.disabled = true
	$AnimatedSprite.visible = false # Replace with function body.

func collapse():
	anim.animation = "Falling"
	anim.play()
