extends Node2D

export(String, FILE, ".tscn") var worldScene

export var seconds_on: int
export var seconds_off: int

var is_on = false





func _on_DeadlyPart_body_entered(body):
	if body is Player:
		get_tree().change_scene(worldScene) # Replace with function body.


func _on_Timer_timeout():
	if (is_on):
		is_on = false
		$DeadlyPart/CollisionShape2D.disabled = true
		$DeadlyPart/AnimatedSprite.animation = "Off"
		$Timer.start(seconds_off)
	else:
		is_on = true
		$DeadlyPart/CollisionShape2D.disabled = false
		$DeadlyPart/AnimatedSprite.animation = "On"
		$Timer.start(seconds_on)
		
