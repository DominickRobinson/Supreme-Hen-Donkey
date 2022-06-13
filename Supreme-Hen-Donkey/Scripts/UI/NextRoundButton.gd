extends Button


func _ready():
	Globals.GM.connect('switchMode', self, 'textMode')


func textMode(mode):
	match mode:
		Globals.Modes.PLAYING:
			set_text('Give Up')
			
		Globals.Modes.BUILDING:
			set_text('Next Player')


func _pressed():
	match Globals.GM.currMode:
		Globals.Modes.PLAYING:
			Globals.GM.die()
		
		Globals.Modes.BUILDING:
			#Globals.GM.advanceRound()
			Globals.GM.match_flow()
