extends Node

var main_theme = load("res://GCS - SHD/music/me_when_the_jimmy_deans_microwave_breakfast_is_done.wav")

func _ready():
	pass 

func play_music():
	
	$Music.stream = main_theme
	$Music.play()
