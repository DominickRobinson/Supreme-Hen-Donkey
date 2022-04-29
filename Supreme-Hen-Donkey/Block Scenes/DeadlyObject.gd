extends Node2D

export(String, FILE, ".tscn") var worldScene

var enabled := true
onready var dragCollider = $DragCollider

# Called when the node enters the scene tree for the first time.
func _process(delta):
	var bodies = $DeadlyPart.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			if Globals.GM is GameManagerMP:
				Globals.GM.die()
			else:
				get_tree().change_scene(worldScene)
