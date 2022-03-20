extends KinematicBody2D

export var RADIUS := 60.0
export var ROTATION_SPEED := 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
	#$CollisionPolygon2D.shape.radius = RADIUS


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	rotation += delta*ROTATION_SPEED
