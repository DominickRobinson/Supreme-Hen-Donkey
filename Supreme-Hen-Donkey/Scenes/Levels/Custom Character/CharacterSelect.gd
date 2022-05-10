extends VBoxContainer

export var PLAYER_NUM := 1

onready var star = $Star
onready var b0 = $S0
onready var b1 = $S1
onready var b2 = $S2


func _ready():
	
#	b0.connect("toggled", self, "_on_S0_pressed")
#	b1.connect("toggled", self, "_on_S1_pressed")
#	b2.connect("toggled", self, "_on_S2_pressed")
	
	toggle(PLAYER_NUM)
	
	$S1.icon = Globals.customSprites[0]
	$S2.icon = Globals.customSprites[1]


func _on_S0_pressed():
	toggle(0)

func _on_S1_pressed():
	toggle(1)

func _on_S2_pressed():
	toggle(2)

func toggle(num):
	# Changing the selected sprite
	Globals.playerSprites[PLAYER_NUM-1] = num
	
	# Positioning the star
	var x
	if PLAYER_NUM == 1:
		x = -45
	else:
		x = 145
	
	var y = 45 + 135 * int(num)
	
	star.position = Vector2(x, y)
		
	#star.position = Vector2(-45 , 45 + 135 * int(num))
