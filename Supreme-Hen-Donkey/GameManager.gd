extends Node2D

var currPlayer := 1
var currMode = Globals.Modes.PLAYING

export(NodePath) var playerNP: NodePath
onready var player = get_node(playerNP)

signal switchMode(mode)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func changeEnabled(obj, enabled):
	obj.set_process(enabled)
	obj.set_physics_process(enabled)
	obj.set_process_input(enabled)


func _input(event):
	if event.is_action_pressed("debug1"):
		print("Disabling")
		switchMode()


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

