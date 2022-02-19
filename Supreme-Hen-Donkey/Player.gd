extends RigidBody2D

export var HORIZONTAL_MAX_SPEED := 500.0
export var HORIZONTAL_IMPULSE := 50.0
export var JUMP_SPEED := 600

# The `onready` keyword tells Godot to only bind this variable once the scene is fully loaded
# The `$` operator gets the node of that name relative to this node
onready var left_zone = $LeftJumpZone
onready var right_zone = $RightJumpZone
onready var bottom_zone = $BottomJumpZone

# The `_ready()` function: called once the scene is fully loaded
# Equivalent to `void Start()` in Unity
func _ready():
	pass

# The `_process()` function: called once per frame/game tick
# Equivalent to `void Update()` in Unity
func _process(_delta: float):
	pass

func _physics_process(delta: float):
	# Getting inputs: actions are defined in Project->Project Settings->Input Map
	# Net horizontal movement
	var x := Input.get_action_strength("right") - Input.get_action_strength("left")
#	apply_central_impulse(Vector2(x*HORIZONTAL_IMPULSE, 0))
#	linear_velocity.x = x*HORIZONTAL_SPEED
	linear_velocity.x = lerp(linear_velocity.x, x*HORIZONTAL_MAX_SPEED, 0.1)
#	if abs(linear_velocity.x) < abs(x*HORIZONTAL_MAX_SPEED):
#		apply_central_impulse(Vector2(x*HORIZONTAL_IMPULSE, 0))
	
	
	if Input.is_action_just_pressed("jump"):
		# If we're on floor, jump normally
#		print(bottom_zone.get_overlapping_bodies().empty())
		if not bottom_zone.get_overlapping_bodies().empty():
			linear_velocity.y = -JUMP_SPEED
		# If we're not on the floor and we're on a wall, 
		elif not left_zone.get_overlapping_bodies().empty():
#			linear_velocity
			pass
