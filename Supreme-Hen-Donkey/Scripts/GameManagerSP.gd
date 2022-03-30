# A game manager for SINGLEPLAYER mode only

extends Node2D

var difficulty = Globals.Difficulties.EASY
export(NodePath) var playerNP: NodePath
onready var player = get_node(playerNP)


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.GM = self
	
	player.connect("finished", self, "resetMultiplayerLevel")


func die():
	if difficulty != Globals.Difficulties.EASY:
		Globals.lives -= 1

	if Globals.lives == 0:
		gameOver()

	respawn()


func gameOver():
	return


func respawn():
	player.resetPosition()
	

func changeEnabled(obj, enabled):
	obj.set_process(enabled)
	obj.set_physics_process(enabled)
	obj.set_process_input(enabled)


func _input(event):
	pass


func resetMultiplayerLevel():
	get_tree().change_scene("res://Scenes/Levels/BlankMultiplayerScene.tscn")
