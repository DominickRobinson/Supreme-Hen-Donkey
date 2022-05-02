extends Node

var fast_theme = load("res://GCS - SHD/music/fast.wav")
var slow_theme = load("res://GCS - SHD/music/slow.wav")
var boss_theme1 = load("res://GCS - SHD/music/honkey-music/boss1.mp3")
var boss_theme2 = load("res://GCS - SHD/music/honkey-music/boss2.mp3")
var boss_theme3 = load("res://GCS - SHD/music/honkey-music/boss3.mp3")

var curr_num = 0

func _ready():
	pass 

func play_music(num):
	
	$Music.stream_paused = false
	
	if num != curr_num:
	
		if num == 0:
			turn_off()
			
		elif num == 1:
			play_slow()
		
		elif num == 2:
			play_fast()
		
		elif num == 3:
			play_boss()
			
		curr_num = num
		
	else:
		pass
		

func play_slow():
	$Music.stream = slow_theme
	$Music.play()
	
func play_fast():
	$Music.stream = fast_theme
	$Music.play()
	
func play_boss():
	$Music.stream = boss_theme1
	$Music.play()
	
func turn_off():
	$Music.stop()
	$Music.stream_paused = true
	
func _on_Music_finished():
	$Music.play()
	
	
