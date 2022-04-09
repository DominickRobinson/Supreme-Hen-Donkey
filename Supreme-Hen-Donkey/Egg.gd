extends KinematicBody2D
export var gravity := 1200

var speed = 750
var velocity = Vector2()

func start(pos, dir):
	rotation = dir
	position = pos
	#print(rotation)
	velocity = Vector2(speed, 0).rotated(rotation+deg2rad(180))

func _physics_process(delta):
	velocity.y += gravity * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
