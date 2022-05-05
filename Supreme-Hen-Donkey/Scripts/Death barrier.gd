extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			if Globals.GM is GameManagerMP:
				Globals.GM.die()
			else:
				#get_tree().change_scene(worldScene)
				get_tree().change_scene(get_tree().current_scene.filename)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
