extends Node2D

var currPlayer := 1
var currMode = Globals.Modes.PLAYING
var difficulty = Globals.Difficulties.EASY
var bothBuilt := false
export(NodePath) var playerNP: NodePath
onready var player = get_node(playerNP)

signal switchMode(mode)
signal switchPlayer(player)

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.GM = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func die():
	if difficulty != Globals.Difficulties.EASY:
		Globals.lives -= 1

	if Globals.lives == 0:
		gameOver()

	respawn()


func gameOver():
	return

func respawn():
	return

func changeEnabled(obj, enabled):
	obj.set_process(enabled)
	obj.set_physics_process(enabled)
	obj.set_process_input(enabled)


func _input(event):
	if event.is_action_pressed("debug1"):
		advanceRound()


func getNextPlayer():
	return (currPlayer % 2) + 1


func advanceRound():
	if currMode == Globals.Modes.PLAYING:
		currPlayer = getNextPlayer()
		switchMode()

	elif currMode == Globals.Modes.BUILDING:
		currPlayer = getNextPlayer()
		if !bothBuilt:
			bothBuilt = true
		else:
			bothBuilt = false
			switchMode()

	print(currPlayer)
	emit_signal('switchPlayer', currPlayer)


func switchMode():
	if currMode == Globals.Modes.PLAYING:
		switchModeBuilding()

	elif currMode == Globals.Modes.BUILDING:
		switchModePlaying()


func switchModePlaying():
	currMode = Globals.Modes.PLAYING
	changeEnabled(player, true)
	emit_signal('switchMode', Globals.Modes.PLAYING)


func switchModeBuilding():
	currMode = Globals.Modes.BUILDING
	changeEnabled(player, false)
	emit_signal('switchMode', Globals.Modes.BUILDING)
