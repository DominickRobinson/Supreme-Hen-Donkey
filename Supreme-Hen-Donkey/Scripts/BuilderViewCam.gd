extends Camera2D


func _ready():
	Globals.GM.connect("switchMode", self, "_on_GameManager_switchMode")


# Make current camera when we're in build mode
func _on_GameManager_switchMode(mode):
	if mode == Globals.Modes.BUILDING:
		make_current()
