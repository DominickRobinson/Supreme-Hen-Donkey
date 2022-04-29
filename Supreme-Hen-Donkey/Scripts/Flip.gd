extends ColorRect


var next_scene
var next_video

export(String, FILE, ".jpg") var IMAGE := ""

export(String, FILE, ".webm") var LEFT_VIDEO := ""
export(String, FILE, ".webm") var RIGHT_VIDEO := ""
export(String, FILE, ".webm") var UNDER_VIDEO := ""

export(String, FILE, ".tscn") var LEFT_SCENE := ""
export(String, FILE, ".tscn") var RIGHT_SCENE := ""
export(String, FILE, ".tscn") var UNDER_SCENE := ""

onready var image = $Image
onready var video = $Video



func _ready():
	
	image.texture = load(IMAGE)
	image.expand = true
	video.expand = true


func _input(event):
	
	if event.is_action_pressed("right") and RIGHT_SCENE != "":	
		flip("r")
		
	elif event.is_action_pressed("left") and LEFT_SCENE != "":
		flip("l")
		
	elif event.is_action_pressed("jump") and UNDER_SCENE != "":
		flip("u")
		
	elif event.is_action_pressed("ui_home"):
		print("exit")
		get_tree().change_scene("res://Scenes/BinderFlips/Main menu/00.tscn")


func flip(dir):

	if dir == "l":
		next_scene = LEFT_SCENE
		next_video = LEFT_VIDEO
					
	elif dir == "r":
		next_scene = RIGHT_SCENE
		next_video = RIGHT_VIDEO
				
	elif dir == "u":
		next_scene = UNDER_SCENE
		next_video = UNDER_VIDEO
		
	if next_video != "":
		video.stream = load(next_video)
	else:
		get_tree().change_scene(next_scene)
		
	if dir != "":
		image.visible = false
		#video.expand = true
		video.play()

	
func _on_Video_finished():
	get_tree().change_scene(next_scene)
