extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$Player.x = 0
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
