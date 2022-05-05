extends VBoxContainer

export var PLAYER_NUM := "1"

onready var star = $Star
onready var b0 = $S0
onready var b1 = $S1
onready var b2 = $S2


func _ready():
	
#	b0.connect("toggled", self, "_on_S0_pressed")
#	b1.connect("toggled", self, "_on_S1_pressed")
#	b2.connect("toggled", self, "_on_S2_pressed")
	
	if PLAYER_NUM == "1":
		toggle(Globals.P1Sprite)
	else:
		toggle(Globals.P2Sprite)



func _on_S0_pressed():
	toggle("0")

func _on_S1_pressed():
	toggle("1")

func _on_S2_pressed():
	toggle("2")

func toggle(num):
	if PLAYER_NUM == "1":
		Globals.P1Sprite = num
		star.position = Vector2(-45 , 45 + 135 * int(num))
	else:
		Globals.P2Sprite = num
		star.position = Vector2(145 , 45 + 135 * int(num))
		
	#star.position = Vector2(-45 , 45 + 135 * int(num))
