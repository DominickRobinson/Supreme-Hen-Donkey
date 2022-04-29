extends TextureRect

export(Array, Texture) var screens
# Player 1 Builds
# Player 1 Plays
# Player 2 Builds
# Player 1 Player


func _ready():
	visible = false
	Globals.GM.connect('switchPlayer', self, 'switchPlayer')
	
	switchPlayer(Globals.GM.currPlayer)


func switchPlayer(player):
	visible = true
	
	# Gets correct index
	var i := 0
	
	if Globals.GM.currMode == Globals.Modes.PLAYING:
		i += 1
	
	i += (player - 1) * 2
	
	# Set texture
	texture = screens[i]
	
	# Make not visible
	$Timer.start()
	yield($Timer, "timeout")
	visible = false
	
	if Globals.GM.currMode == Globals.Modes.PLAYING:
		Globals.GM.changeEnabled(Globals.GM.player, true)
