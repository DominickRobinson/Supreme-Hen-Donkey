extends Area2D

export(String, FILE, ".tscn") var worldScene

var enabled := true
onready var dragCollider = $DragCollider

# Called when the node enters the scene tree for the first time.
func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene(worldScene)
