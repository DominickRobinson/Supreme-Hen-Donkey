extends KinematicBody2D

export var HORIZONTAL_SPEED := 60.0
export var TRAVEL_DISTANCE := 200.0
export var HEIGHT := 120.0
export var WIDTH := 120.0
export var ROTATION := 24

var enabled := false


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.extents.x = WIDTH
	$CollisionShape2D.shape.extents.y = HEIGHT
	$CollisionShape2D.shape.extents.y = HEIGHT
	rotation = deg2rad(ROTATION)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
var travel_forward := true
var current_distance := 0
var x := 0
func _process(delta):
	if not enabled:
		return
		
	if travel_forward:
		move_and_collide(delta * Vector2(HORIZONTAL_SPEED,0).rotated(rotation))
		current_distance += (delta*HORIZONTAL_SPEED)
	else:
		move_and_collide(delta * Vector2(-1*HORIZONTAL_SPEED,0).rotated(rotation))
		current_distance += (delta*HORIZONTAL_SPEED)
	if current_distance > TRAVEL_DISTANCE:
		travel_forward = not travel_forward
		current_distance = 0
#func _physics_process(delta):
#	rotation = deg2rad(45)
