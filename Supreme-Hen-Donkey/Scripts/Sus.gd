extends Node

export var dialogue: String
export var always_show := false

onready var zone = $Activate
onready var dial = $Dialogue
onready var bg = $Dialogue/ColorRect


func _ready():
	#dial.text = dialogue
	dial.bbcode_text = dialogue
	bg.rect_size = dial.rect_size 

func _process(delta):
	dial.visible = check_for_player()

func check_for_player():
	if always_show:
		return true
	
	for body in zone.get_overlapping_bodies():
		if body is Player:
			return true
	return false
