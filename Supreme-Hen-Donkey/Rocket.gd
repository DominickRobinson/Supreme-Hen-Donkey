extends KinematicBody2D

export var move_speed := 100  # pixels/sec
export var radius := 150  # pixels
export var flame_deadly := false
export var turn_right := true

export var enabled := false
onready var dragCollider = $CollisionPolygon2D

var mult = 1

func _ready():
	if not turn_right:
		mult = -1

func _physics_process(delta):
	if !enabled:
		return
	
	if flame_deadly:
		$Flame.make_deadly()
	else:
		$Flame.make_safe()
	
	
	var a = 0
	if radius != 0:
		a = 2 * asin(move_speed * delta / (2 * radius))
	rotation += mult * a
	#$Sprite.rotation += a
	#$CollisionShape2D.rotation += a
	move_and_collide(transform.x * move_speed * delta)
