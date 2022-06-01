extends RichTextLabel


func _ready():
	#dial.text = dialogue
	bbcode_text += " " + str(Globals.death_counter) 
