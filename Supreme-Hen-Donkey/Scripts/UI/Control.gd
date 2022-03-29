extends Control


func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			_on_Start_pressed()

func _on_Start_pressed():
	$Sprite.visible = false
	$Transition.play()
	
func _on_Transition_finished():
	 get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
