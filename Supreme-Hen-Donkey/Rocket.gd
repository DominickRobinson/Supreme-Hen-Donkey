extends KinematicBody2D

export var move_speed := 100  # pixels/sec
export var radius := 150  # pixels

func _physics_process(delta):
	var a = 2 * asin(move_speed * delta / (2 * radius))
	rotation += a
	#$Sprite.rotation += a
	#$CollisionShape2D.rotation += a
	move_and_collide(transform.x * move_speed * delta)
