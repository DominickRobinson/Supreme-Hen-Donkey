extends KinematicBody2D

export var HORIZONTAL_SPEED := 60.0
export var TRAVEL_DISTANCE := 200.0
export var HEIGHT := 120.0
export var WIDTH := 120.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.extents.x = WIDTH
	$CollisionShape2D.shape.extents.y = HEIGHT


# Called every frame. 'delta' is the elapsed time since the previous frame.
var travel_forward := true
var current_distance := 0
var x := 0
func _process(delta):
	if travel_forward:
		move_and_collide(delta * Vector2(HORIZONTAL_SPEED,0))
		current_distance += (delta*HORIZONTAL_SPEED)
	else:
		move_and_collide(delta * Vector2(-1*HORIZONTAL_SPEED,0))
		current_distance += (delta*HORIZONTAL_SPEED)
	if current_distance > TRAVEL_DISTANCE:
		travel_forward = not travel_forward
		current_distance = 0
	
