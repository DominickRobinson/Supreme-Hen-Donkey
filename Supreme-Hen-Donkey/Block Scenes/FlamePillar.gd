extends Node2D

export(String, FILE, ".tscn") var worldScene

export var seconds_on: float
export var seconds_off: float

var is_on = false

var enabled := true
onready var dragCollider = $DragCollider


func _on_DeadlyPart_body_entered(body):
	if body is Player:
		if Globals.GM is GameManagerMP:
			Globals.GM.die()
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
		
