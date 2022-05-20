extends Node2D

export(String, FILE, ".tscn") var worldScene

#export var seconds_on: float
#export var seconds_off: float
export var seconds_on := 2.0
export var seconds_off := 3.0
export var stagger := 1.0

var is_on = false

var enabled := true
onready var dragCollider = $DragCollider

func _ready():
	$DeadlyPart/CollisionShape2D.disabled = true
	$DeadlyPart/AnimatedSprite.animation = "Off"
	$Timer.start(stagger)

	

func _on_DeadlyPart_body_entered(body):
	
	if not is_on:
		return
	
	if body is Player and !body.dead:
		if Globals.GM is GameManagerMP:
			Globals.GM.die()
		#get_tree().change_scene(worldScene) # Replace with function body.
		get_tree().change_scene(get_tree().current_scene.filename)

func _on_Timer_timeout():
	if is_on:
		is_on = false
		$DeadlyPart/CollisionShape2D.disabled = true
		$DeadlyPart/AnimatedSprite.animation = "Off"
		$Timer.start(seconds_off)
	else:
		is_on = true
		$DeadlyPart/CollisionShape2D.disabled = false
		$DeadlyPart/AnimatedSprite.animation = "On"
		$Timer.start(seconds_on)
		
