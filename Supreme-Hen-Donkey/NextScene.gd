extends Area2D

export(String, FILE, ".tscn") var worldScene

#export(String, FILE, ".webm") var transitionVideo



# Called when the node enters the scene tree for the first time.
func _process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			get_tree().change_scene(worldScene)
			#get_tree().change_scene(get_tree().current_scene.filename)
			
func _input(event):
	if event.is_action_pressed("reset_level"):
		get_tree().change_scene(get_tree().current_scene.filename)
		#get_tree().reload_current_scene()	
