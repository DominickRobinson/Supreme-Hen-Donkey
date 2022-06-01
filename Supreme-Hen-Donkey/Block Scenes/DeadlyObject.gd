extends Node2D

export(String, FILE, ".tscn") var worldScene

var enabled := true
onready var dragCollider = $DragCollider

export var FLAME_DEADLY := true

# Called when the node enters the scene tree for the first time.
func _process(delta):
	
	if not FLAME_DEADLY:
		return
	
	var bodies = $DeadlyPart.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			if Globals.GM is GameManagerMP:
				Globals.GM.die()
			else:
				body.die()
				

func make_deadly():
	FLAME_DEADLY = true
	
func make_safe():
	FLAME_DEADLY = false 
