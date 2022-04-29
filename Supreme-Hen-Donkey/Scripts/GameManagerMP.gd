# A game manager for MULTIPLAYER mode only
class_name GameManagerMP
extends Node2D

var roundsLeft = Globals.MAX_ROUNDS
var currPlayer := 1
var currMode = Globals.Modes.BUILDING
var difficulty = Globals.Difficulties.EASY
var bothBuilt := false

var onePlayerWon := false
var mustWin := false

export(NodePath) var playerNP: NodePath
onready var player = get_node(playerNP)
export(NodePath) var builderViewNP: NodePath
onready var builderView = get_node(builderViewNP)
export(NodePath) var startBlockNP: NodePath
onready var startBlock = get_node(startBlockNP)
export(NodePath) var endBlockNP: NodePath
onready var endBlock = get_node(endBlockNP)

signal switchMode(mode)
signal switchPlayer(player)


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.GM = self
	
	player.connect("finished", self, "playerFinished")
	
	switchModeBuilding()


func die():
	if mustWin:
		var winningPlayer = getNextPlayer()
		matchOver(winningPlayer)
	
	if !player.dead:
		player.dead = true
		respawn()
		advanceRound()


func matchOver(winningPlayer):
	if winningPlayer != -1:
		print('Player %d won!' % winningPlayer)
		Globals.winTally[winningPlayer-1] += 1
	
	resetMultiplayerLevel()


func respawn():
	player.resetPosition()


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
		# Update rounds left
		roundsLeft -= 1
		if roundsLeft == 0:
			matchOver(-1)
			return
			
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
	# Player is re-enabled after sticky note hides itself
	changeEnabled(builderView, false)
	emit_signal('switchMode', Globals.Modes.PLAYING)


func switchModeBuilding():
	currMode = Globals.Modes.BUILDING
	changeEnabled(player, false)
	changeEnabled(builderView, true)
	emit_signal('switchMode', Globals.Modes.BUILDING)


# What to do if a player completes the level
func playerFinished():
	respawn()
	# Nobody has won before, so the next player must win or else lose
	if !onePlayerWon:
		onePlayerWon = true
		mustWin = true
		currPlayer = getNextPlayer()
		switchModeBuilding()
		switchModePlaying()
		
		print('Player %d must finish or else they will lose!' % currPlayer)
		emit_signal('switchPlayer', currPlayer)
	
	# Both players have won, so go back to the building stage
	else:
		onePlayerWon = false
		mustWin = false
		advanceRound()


func resetMultiplayerLevel():
	get_tree().change_scene("res://Scenes/Levels/BlankMultiplayerScene.tscn")

















