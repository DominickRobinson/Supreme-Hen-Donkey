extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Multiplayer_pressed():
	get_tree().change_scene("res://Scenes/Levels/BlankMultiplayerScene.tscn")


func _on_Single_Player_pressed():
	$Sprite.visible = false
	$Transition.play()
	

func _on_Level_Editor_pressed():
	pass # Replace with function body.


func _on_Character_Customization_pressed():
	pass # Replace with function body.


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Transition_finished():
	get_tree().change_scene("res://Scenes/Levels/1-1.tscn")
	
