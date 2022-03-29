extends Area2D

export(String, FILE, ".tscn") var worldScene

# Called when the node enters the scene tree for the first time.
func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene(worldScene)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
