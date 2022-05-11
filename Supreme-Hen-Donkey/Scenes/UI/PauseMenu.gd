extends Control

export(String, FILE, ".tscn") var LEVEL_SELECT


var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		
		if is_paused == false:
			print("pausing...")
		else:
			print("unpausing...")
		
		self.is_paused = !is_paused
		visible = is_paused


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused



func _on_Continue_pressed():
	unpause()


func _on_Restart_pressed():
	unpause()
	get_tree().change_scene(get_tree().current_scene.filename)


func _on_LevelSelect_pressed():
	unpause()
	get_tree().change_scene(LEVEL_SELECT)


func _on_MainMenu_pressed():
	unpause()
	get_tree().change_scene("res://Scenes/BinderFlips/Main menu/00.tscn")



func unpause():
	self.is_paused = false
	visible = is_paused

