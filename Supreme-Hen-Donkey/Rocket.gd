extends KinematicBody2D

export var move_speed := 100  # pixels/sec
export var radius := 150  # pixels

export var enabled := false
onready var dragCollider = $CollisionPolygon2D

func _physics_process(delta):
	if !enabled:
		return
	
	var a = 2 * asin(move_speed * delta / (2 * radius))
	rotation += a
	#$Sprite.rotation += a
	#$CollisionShape2D.rotation += a
	move_and_collide(transform.x * move_speed * delta)
