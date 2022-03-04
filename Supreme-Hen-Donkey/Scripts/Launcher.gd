extends Area2D

export var LAUNCH_IMPULSE := Vector2(0, -1000)

func _input(event: InputEvent):
	if event.is_action_pressed("debug1"):
		for body in get_overlapping_bodies():
			if body is RigidBody2D:
				body.apply_central_impulse(LAUNCH_IMPULSE)
