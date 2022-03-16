extends Label


func _ready():
	set_text('Mode: Playing\nYou cannot drag tiles and can move\nPress e to switch')
	get_node("/root/DemoScene/GameManager/").connect('switchMode', self, '_on_switchMode')
	

func _on_switchMode(mode):
	match mode:
		Globals.Modes.PLAYING:
			set_text('Mode: Playing\nYou cannot drag tiles and can move\nPress e to switch')
			
		Globals.Modes.BUILDING:
			set_text('Mode: Building\nYou can drag tiles and cannot move\nPress e to switch')
