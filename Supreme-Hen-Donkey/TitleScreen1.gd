extends Control


func _on_Multiplayer_pressed():

	get_tree().change_scene("res://DemoScene.tscn")


func _on_Single_Player_pressed():
	$Sprite.visible = false
	$Transition.play()
	

func _on_How_to_Play_pressed():
	pass # Replace with function body.


func _on_Character_Customization_pressed():
	get_tree().change_scene("res://paint_root.tscn")


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Transition_finished():
	get_tree().change_scene("res://1-1.tscn")
	
