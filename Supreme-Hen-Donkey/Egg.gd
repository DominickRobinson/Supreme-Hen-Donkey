extends KinematicBody2D
export var gravity := 1200
export var timer := 1

var velocity = Vector2()
var start_time = OS.get_ticks_msec()

func start(pos, dir, speed):
	rotation = dir
	position = pos
#	print("Dir:")
#	print(dir)
#	print("Rotation:")
#	print(rotation)
	velocity = Vector2(speed, 0).rotated(deg2rad(-rotation))
	print(velocity)

func _physics_process(delta):
	velocity.y += gravity * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()
	if(OS.get_ticks_msec() - start_time > timer * 1000):
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
