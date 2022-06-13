extends Control


export var enabled := true
export var delay := 1.0

onready var video = $VideoPlayer
onready var timer = $Timer


func _ready():
	
	if not enabled:
		return false
	
	timer.wait_time = delay
	timer.start()
	video.visible = false

func _on_VideoPlayer_finished():
	video.visible = false

func _on_Timer_timeout():
	timer.stop()
	video.visible = true
	video.play()
