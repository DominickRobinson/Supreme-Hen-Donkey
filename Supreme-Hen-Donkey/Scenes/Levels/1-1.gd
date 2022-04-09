extends Node2D
onready var Camera1 = get_tree().get_nodes_in_group("PlayerCamera")[0]
onready var Camera2 = $Camera2D
func _ready():
	Camera1.current = true
	Camera2.current = false
	pass
func _input(event):
	if event.is_action_pressed("switch"):
		if(not Camera1.current):
			Camera1.current = true
			Camera2.current = false
		else:
			Camera1.current = false
			Camera2.current = true
