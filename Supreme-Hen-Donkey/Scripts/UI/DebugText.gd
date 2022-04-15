extends VBoxContainer

var debugOn := true

func _ready():
	Globals.debugText = self
	
	$WinText.set_text('Win Tally: %d - %d' % [Globals.winTally[0], Globals.winTally[1]])
	$RoundText.set_text('%d Rounds Left' % Globals.MAX_ROUNDS)
	textMode(Globals.GM.currMode)
	$PlayingText.set_text('Player 1\n')
	
	Globals.GM.connect('switchMode', self, 'textMode')
	Globals.GM.connect('switchPlayer', self, 'textPlayer')


func textMode(mode):
	match mode:
		Globals.Modes.PLAYING:
			$ModeText.set_text('Mode: Playing\nYou cannot drag tiles and can move\nPress e to switch\n')
			
		Globals.Modes.BUILDING:
			$ModeText.set_text('Mode: Building\nYou can drag tiles and cannot move\nPress e to switch\n')


func textPlayer(player):
	$PlayingText.set_text('Player %d\n' % player)
	
	if Globals.GM.roundsLeft > 1:
		$RoundText.set_text('%d Rounds Left' % Globals.GM.roundsLeft)
	else:
		$RoundText.set_text('Last Round!')
