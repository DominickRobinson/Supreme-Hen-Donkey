extends ColorRect


var next_scene
var next_video

export var TURN_CURR_MUSIC_OFF := false

export(String, FILE, ".jpg") var IMAGE := ""

export(String, FILE, ".webm") var LEFT_VIDEO := ""
export(String, FILE, ".webm") var RIGHT_VIDEO := ""
export(String, FILE, ".webm") var UNDER_VIDEO := ""

export(String, FILE, ".tscn") var LEFT_SCENE := ""
export(String, FILE, ".tscn") var RIGHT_SCENE := ""
export(String, FILE, ".tscn") var UNDER_SCENE := ""

export var MUSIC_NUM := 0

export var autostart := false

export var extra := false

onready var image = $Image
onready var video = $Video

onready var la = $LeftArrow
onready var ra = $RightArrow
onready var da = $DownArrow

#var music_player = get_node("res://autoloads/MusicController.tscn")

func _ready():
	
	print("Current scene: " + get_tree().current_scene.filename)
	
	image.texture = load(IMAGE)
	image.expand = true
	video.expand = true
	
	if TURN_CURR_MUSIC_OFF:
		#print("should turn off music\n")
		MusicController.turn_off()
	else:
		MusicController.play_music(MUSIC_NUM)
		
	if LEFT_SCENE != "":
		la.visible = true
	if RIGHT_SCENE != "":
		ra.visible = true
	if UNDER_SCENE != "":
		da.visible = true
		
	if autostart:
		flip("u")

	


 
func _input(event):
	
	if video.is_playing() and event.is_action_pressed("skip_video"):
		#print("should skip video")
		_on_Video_finished()
		
	if video.is_playing():
		
		if next_scene == RIGHT_SCENE and event.is_action_pressed("right"):
			_on_Video_finished()
		elif next_scene == LEFT_SCENE and event.is_action_pressed("left"):
			_on_Video_finished()	
		elif next_scene == UNDER_SCENE and event.is_action_pressed("ui_down"):
			_on_Video_finished()
		
	
	if event.is_action_pressed("right") and RIGHT_SCENE != "":	
		flip("r")
		
	elif event.is_action_pressed("left") and LEFT_SCENE != "":
		flip("l")
		
	elif event.is_action_pressed("ui_down") and UNDER_SCENE != "":
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
		
	
	if extra:
		if get_parent().get_node("Extra") != null:
			get_parent().get_node("Extra").visible = false
		
	
	
	
	if next_video != "":
		video.stream = load(next_video)
	else:
		print("Next scene:    " + next_scene)
		get_tree().change_scene(next_scene)
		
	if dir != "":
		image.visible = false
		#video.expand = true
		video.play()

	
func _on_Video_finished():
	print("Next scene:    " + next_scene)
	get_tree().change_scene(next_scene)
