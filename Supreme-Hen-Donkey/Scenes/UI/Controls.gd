extends Control

onready var mp = $MP
onready var sp = $SP



func _ready():
	update_controls()

func _physics_process(delta):
	update_controls()
	#pass

func update_controls():
	if Globals.GM != null:
		if Globals.GM is GameManagerMP:
			print("MP uwu")
			mp.visible = true
			sp.visible = false
	
	else:
		print("SP")
		mp.visible = false
		sp.visible = true
