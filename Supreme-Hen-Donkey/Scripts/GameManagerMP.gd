# A game manager for MULTIPLAYER mode only
class_name GameManagerMP
extends Node2D

var currPlayer := 1
var currMode = Globals.Modes.PLAYING
var difficulty = Globals.Difficulties.EASY
var bothBuilt := false

export(NodePath) var playerNP: NodePath
onready var player = get_node(playerNP)
export(NodePath) var builderViewNP: NodePath
onready var builderView = get_node(builderViewNP)

signal switchMode(mode)
signal switchPlayer(player)


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.GM = self
	
	changeEnabled(builderView, false)
	
	player.connect("finished", self, "resetMultiplayerLevel")


func die():
	if !player.dead:
		player.dead = true
		respawn()


func gameOver():
	return


func respawn():
	player.resetPosition()
	advanceRound()
	

func changeEnabled(obj, enabled):
	obj.visible = enabled
	obj.set_process(enabled)
	obj.set_physics_process(enabled)
	obj.set_process_input(enabled)


# Changes object to be top-level
func changeParentage(obj):
	obj.get_parent().remove_child(obj)
	get_tree().current_scene.add_child(obj)


func _input(event):
	if event.is_action_pressed("debug1"):
		advanceRound()


func getNextPlayer():
	return (currPlayer % 2) + 1


func advanceRound():
	# If we're playing, switch to building
	if currMode == Globals.Modes.PLAYING:
		currPlayer = getNextPlayer()
		switchMode()
	
	# If we're building, switch to playing if both players have built
	elif currMode == Globals.Modes.BUILDING:
		currPlayer = getNextPlayer()
		if !bothBuilt:
			bothBuilt = true
		else:
			bothBuilt = false
			switchMode()

	emit_signal('switchPlayer', currPlayer)


func switchMode():
	if currMode == Globals.Modes.PLAYING:
		switchModeBuilding()

	elif currMode == Globals.Modes.BUILDING:
		switchModePlaying()


func switchModePlaying():
	currMode = Globals.Modes.PLAYING
	changeEnabled(player, true)
	changeEnabled(builderView, false)
	Physics2DServer.set_active(true)
	emit_signal('switchMode', Globals.Modes.PLAYING)


func switchModeBuilding():
	currMode = Globals.Modes.BUILDING
	changeEnabled(player, false)
	changeEnabled(builderView, true)
	
	emit_signal('switchMode', Globals.Modes.BUILDING)


func resetMultiplayerLevel():
	get_tree().change_scene("res://Scenes/Levels/BlankMultiplayerScene.tscn")
