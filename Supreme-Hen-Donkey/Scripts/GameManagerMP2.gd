# A game manager for MULTIPLAYER mode only
class_name GameManagerMP
extends Node2D

var roundsLeft = Globals.MAX_ROUNDS
var currPlayer := 1
var currMode = Globals.Modes.BUILDING
var difficulty = Globals.Difficulties.EASY
var bothBuilt := false

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


var have_won = [false, false]
var have_run = [false, false]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	roundsLeft = Globals.MAX_ROUNDS
	Globals.GM = self
	
	player = get_sibling("Player")
	startBlock = get_sibling("StartBlock")
	endBlock = get_sibling("EndBlock")
	builderView = get_sibling("BuilderView")
	
	player.connect("finished", self, "win")
	
	switchModeBuilding()

	print_gamestate()


func get_sibling(word):
	return get_parent().get_node(word)

func win():
	print_gamestate()	
	#have_run[currPlayer - 1] = true
	have_won[currPlayer - 1] = true
	match_flow()

func die():
	print_gamestate()	
	#have_run[currPlayer - 1] = true
	have_won[currPlayer - 1] = false
	match_flow()

func match_flow():
		
	currPlayer = getNextPlayer()
	player.CURRENT_PLAYER = currPlayer
	player.change_sprite()
	
	if currMode == Globals.Modes.PLAYING:
		respawn()
		#if check_both_run() and currPlayer == 1:
		if currPlayer == 1:
			assert(currPlayer == 1)
			evaluate_winner()
			switchMode()
			assert(currMode == Globals.Modes.BUILDING)
			roundsLeft -= 1
		else:
			print("PLAYER 2 SHOULD GO NOW!!")
				
	else:
		assert(currMode == Globals.Modes.BUILDING)
		#have_run[currPlayer - 2] = true
		reset_both_run()
		
		if currPlayer == 1:
			#assert(check_both_run())
			switchMode()
			reset_both_run()
		else:
			pass
			
	emit_signal('switchPlayer', currPlayer)
		

func print_gamestate():
	print("")
	print("Current player: %d" % ((currPlayer % 2) + 1))
	#print("Current player: %d" % currPlayer)
	print("Players | %d | %d" % [1, 2])
	print("----------------")
	print("Has run | %d | %d" % [int(have_run[0]), int(have_run[1])])
	print("----------------")
	print("Has won | %d | %d" % [int(have_won[0]), int(have_won[1])])
	print("")


func check_both_run():
	return (have_run[0] == true and have_run[1] == true)

func reset_both_run():
	have_run[0] = false
	have_run[1] = false
	
func reset_both_won():
	have_won[0] = false
	have_run[1] = false
	
func find_winner():
	if have_won[0] and have_won[1]:
		return 0
	elif not have_won[0] and have_won[1]:
		return 2
	elif have_won[0] and not have_won[1]:
		return 1
	elif not have_won[0] and not have_won[1]:
		return 0
	
	assert(false)

func evaluate_winner():
	#assert(check_both_run())
	var winningPlayer = find_winner()
	
	if winningPlayer != 0:
		print('and the winner is... Player %d' % winningPlayer)
		Globals.winTally[winningPlayer-1] += 1
		resetMultiplayerLevel()
	else:
		print("\n\n tie lol \n\n")
	
	reset_both_run()
	reset_both_won()

func getNextPlayer():
	var result = (currPlayer % 2) + 1
	emit_signal('switchPlayer', currPlayer)
	return result

func respawn():
	player.resetPosition()

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

func resetMultiplayerLevel():
	get_tree().change_scene(get_tree().current_scene.filename)
	
func _input(event):
	if event.is_action_pressed("debug1"):
		#advanceRound()
		#Globals.GM.die()
		if currMode == Globals.Modes.BUILDING:
			match_flow()
		else:
			die()

func changeEnabled(obj, enabled):
	obj.visible = enabled
	obj.set_process(enabled)
	obj.set_physics_process(enabled)
	obj.set_process_input(enabled)

func changeParentage(obj):
	obj.get_parent().remove_child(obj)
	get_tree().current_scene.add_child(obj)








#func die():
#	if mustWin:
#		var winningPlayer = getNextPlayer()
#		matchOver(winningPlayer)
#
#	if !player.dead:
#		player.dead = true
#		respawn()
#		advanceRound()
#
#
#func matchOver(winningPlayer):
#	if winningPlayer != -1:
#		print('Player %d won!' % winningPlayer)
#		Globals.winTally[winningPlayer-1] += 1
#
#	resetMultiplayerLevel()
#
#
#func respawn():
#	player.resetPosition()
#
#
#func changeEnabled(obj, enabled):
#	obj.visible = enabled
#	obj.set_process(enabled)
#	obj.set_physics_process(enabled)
#	obj.set_process_input(enabled)
#
#
## Changes object to be top-level
#func changeParentage(obj):
#	obj.get_parent().remove_child(obj)
#	get_tree().current_scene.add_child(obj)
#
#
#func _input(event):
#	if event.is_action_pressed("debug1"):
#		#advanceRound()
#		#Globals.GM.die()
#		die()
#
#func getNextPlayer():
#	return (currPlayer % 2) + 1
#
#
#func advanceRound():
#	# If we're playing, switch to building
#	if currMode == Globals.Modes.PLAYING:
#		# Update rounds left
#		roundsLeft -= 1
#		if roundsLeft == 0:
#			matchOver(-1)
#			return
#
#		currPlayer = getNextPlayer()
#		switchMode()
#
#	# If we're building, switch to playing if both players have built
#	elif currMode == Globals.Modes.BUILDING:
#		currPlayer = getNextPlayer()
#		if !bothBuilt:
#			bothBuilt = true
#		else:
#			bothBuilt = false
#			switchMode()
#
#	emit_signal('switchPlayer', currPlayer)
#
#
#func switchMode():
#	if currMode == Globals.Modes.PLAYING:
#		switchModeBuilding()
#
#	elif currMode == Globals.Modes.BUILDING:
#		switchModePlaying()
#
#
#func switchModePlaying():
#	currMode = Globals.Modes.PLAYING
#	# Player is re-enabled after sticky note hides itself
#	changeEnabled(builderView, false)
#	player.CURRENT_PLAYER = currPlayer
#	player.change_sprite()
#	emit_signal('switchMode', Globals.Modes.PLAYING)
#
#
#func switchModeBuilding():
#	currMode = Globals.Modes.BUILDING
#	changeEnabled(player, false)
#	changeEnabled(builderView, true)
#	emit_signal('switchMode', Globals.Modes.BUILDING)
#
#
## What to do if a player completes the level
#func playerFinished():
#	respawn()
#	# Nobody has won before, so the next player must win or else lose
#	if !onePlayerWon:
#		onePlayerWon = true
#		mustWin = true
#		currPlayer = getNextPlayer()
#		switchModeBuilding()
#		switchModePlaying()
#
#		print('Player %d must finish or else they will lose!' % currPlayer)
#		emit_signal('switchPlayer', currPlayer)
#
#	# Both players have won, so go back to the building stage
#	else:
#		onePlayerWon = false
#		mustWin = false
#		advanceRound()
#
#
#func resetMultiplayerLevel():
#	get_tree().change_scene(get_tree().current_scene.filename)
#
#
#














