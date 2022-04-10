extends KinematicBody2D

export var speed := 750
var velocity = Vector2()
export var gravity := 1200

func start(pos, dir):
	rotation = dir
	position = pos
	#print(rotation)
	velocity = Vector2(speed, 0).rotated(deg2rad(rotation + 180))

	#velocity.x = cos(deg2rad(rotation)) * speed
	#velocity.y = -sin(deg2rad(rotation)) * speed

func _physics_process(delta):
	velocity.y += gravity * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
