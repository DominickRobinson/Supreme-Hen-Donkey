extends Node

export var dialogue: String

onready var zone = $Activate
onready var dial = $Dialogue


func _ready():
	dial.text = dialogue

func _process(delta):
	dial.visible = check_for_player()

func check_for_player():
	for body in zone.get_overlapping_bodies():
		if body is Player:
			return true
	#return false	
	return true
