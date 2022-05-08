extends TextureRect

var tileX = []
var tileY := 0

func _ready():
	Globals.GM.connect('switchMode', self, 'switchMode')


func switchMode(mode):
	match mode:
		Globals.Modes.BUILDING:
			visible = true
		Globals.Modes.PLAYING:
			visible = false


func getTilePos():
	tileX = []
	tileY = 0
	
	tileY = $CenterContainer/GridContainer/Control1.rect_position.y
	tileY += rect_position.y
	for node in $CenterContainer/GridContainer.get_children():
		tileX.append(node.rect_position.x + rect_position.x)
	
	print(tileX)
	print(tileY)
