extends CollisionShape2D


# Declare member variables here. Examples:


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Spikes_body_entered(body):
	if (body is Player):
		body.death()
