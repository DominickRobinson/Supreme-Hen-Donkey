extends VBoxContainer

var debugOn := true

func _ready():
	Globals.debugText = self
	$ModeText.set_text('Mode: Playing\nYou cannot drag tiles and can move\nPress e to switch\n')
	Globals.GM.connect('switchMode', self, 'textMode')
	Globals.GM.connect('switchPlayer', self, 'textPlayer')


func textMode(mode):
	match mode:
		Globals.Modes.PLAYING:
			$ModeText.set_text('Mode: Playing\nYou cannot drag tiles and can move\nPress e to switch\n')
			
		Globals.Modes.BUILDING:
			$ModeText.set_text('Mode: Building\nYou can drag tiles and cannot move\nPress e to switch\n')


func textPlayer(player):
	$PlayingText.set_text('Player %d' % player)
