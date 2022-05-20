extends RigidBody2D
class_name Player

# The `export` keyword tells Godot to show this variable in the Inspector
export var HORIZONTAL_MAX_SPEED := 650.0
export var FLOOR_ACCELERATION := 27.0
export var AIR_ACCELERATION := 23.0
export var JUMP_SPEED := 600.0
export var WALL_JUMP_VERTICAL_SPEED := 650.0
export var WALL_JUMP_HORIZONTAL_SPEED := 250.0
export var INITIAL_RUN_VELOCITY := 60
export var AIR_RESISTANCE := 0.00003 

export var CURRENT_PLAYER := 1
var CUSTOM_SPRITE_NUM
export var CUSTOM_SPRITE_ROTATION_SPEED := 12
export var WOBBLE := 10
export var GROUND_WOBBLE_SPEED := 4

var step = 1

var dead = false
var finished = false
var resetPosNextFrame = false
var startPos: Vector2

signal finished()

# The `onready` keyword tells Godot to only bind this variable once the scene is fully loaded
# The `$` operator gets the node of that name relative to this node
onready var left_zone = $LeftJumpZone
onready var right_zone = $RightJumpZone
onready var bottom_zone = $BottomJumpZone
onready var center_zone = $CenterJumpZone
onready var finishTimer = $FinishTimer

export(NodePath) var deathNP: NodePath
onready var deathNode = get_node(deathNP)


func _ready():
	startPos = Vector2(0,0)
	linear_velocity = Vector2(0,0)
	
	change_sprite()
	
	if Globals.GM != null:
		Globals.GM.connect("switchMode", self, "_on_GameManager_switchMode")
		Globals.GM.changeEnabled(self, false)
		
		if Globals.GM is GameManagerMP:
			var startBlock = get_node('../StartBlock/')
			var extraOffset = 0
			if startBlock != null:
				startPos = startBlock.get_node('Node2D').position
			else:
				startPos = Vector2(0,0)


# Lot of functions are called automatically by the engine. These include _ready, _process, etc.
# This gets called on every physics frame. Sort of like FixedUpdate() in Unity.
func _physics_process(_delta: float):
	# Getting inputs: actions are defined in Project->Project Settings->Input Map
	# Net horizontal movement
	var x := Input.get_action_strength("right") - Input.get_action_strength("left")
	
	# Don't allow walking closer to a wall when already on it, so that you don't get stuck on it
	if (is_on_right_wall() and x > 0) or (is_on_left_wall() and x < 0):
		x = 0
		
	
	if (is_on_right_wall() or is_on_left_wall()):
		gravity_scale = .7
	else:
		gravity_scale = 1
	
	if is_on_floor() and x != 0: 
		if abs(linear_velocity.x) <= INITIAL_RUN_VELOCITY:
			linear_velocity.x = x * INITIAL_RUN_VELOCITY
		
		if sign(linear_velocity.x) != x:
			linear_velocity.x += x * 5
			#x = 0	
	
	# Apply horizontal acceleration movement
	var accel := AIR_ACCELERATION
	if is_on_floor():
		accel = FLOOR_ACCELERATION
	
	
	# Only allow acceleration when less than the maximum horizontal speed
	if abs(linear_velocity.x) < HORIZONTAL_MAX_SPEED or sign(linear_velocity.x) != sign(x):
		apply_central_impulse(Vector2(x*accel, 0))
		#print(applied_force)
	

	
	
	# Jumping
	if Input.is_action_just_pressed("jump"):
		# If we're fully on floor, or we've just walked off a ledge (grace zone), jump normally
		if is_on_floor() or (is_maybe_on_floor() and not (is_on_left_wall() or is_on_right_wall())):
			linear_velocity.y = -JUMP_SPEED
		# Otherwise, wall jump if we're on a wall
		elif is_on_left_wall():
#			linear_velocity = Vector2(WALL_JUMP_HORIZONTAL_SPEED, -WALL_JUMP_VERTICAL_SPEED)
			#apply_central_impulse(Vector2(WALL_JUMP_HORIZONTAL_SPEED, -WALL_JUMP_VERTICAL_SPEED))
			linear_velocity.x = WALL_JUMP_HORIZONTAL_SPEED
			linear_velocity.y = -WALL_JUMP_VERTICAL_SPEED
		elif is_on_right_wall():
#			linear_velocity = Vector2(-WALL_JUMP_HORIZONTAL_SPEED, -WALL_JUMP_VERTICAL_SPEED)
			#apply_central_impulse(Vector2(-WALL_JUMP_HORIZONTAL_SPEED, -WALL_JUMP_VERTICAL_SPEED))
			linear_velocity.x = -WALL_JUMP_HORIZONTAL_SPEED
			linear_velocity.y = -WALL_JUMP_VERTICAL_SPEED
		# Otherwise, we're not on a wall or floor, so don't jump
	elif Input.is_action_just_pressed("ui_home"):
		print("exit")
		get_tree().change_scene("res://Scenes/BinderFlips/Main menu/00.tscn")
	
	
	
	#air resistance
	if not is_on_floor():
		if x == 0:
			var ar = -sign(linear_velocity.x) * AIR_RESISTANCE * linear_velocity.x * linear_velocity.x
			if abs(linear_velocity.x) > abs(ar): 
				linear_velocity.x += ar
			else:
				linear_velocity.x *= 0.98
			

	
	checkFell()
	
	if is_on_floor():
	
		if x != 0:
			$AnimatedSprite.speed_scale = 0.3 + 2.2 * abs(linear_velocity.x) / HORIZONTAL_MAX_SPEED
			$AnimatedSprite.animation = "Running"
			physics_material_override.friction = 0.3
			wobble_sprite()
			
			if step == 1:
				step = -1
			else:
				step = 1
			
		else:
			$AnimatedSprite.speed_scale = 1;
			$AnimatedSprite.animation = "Idle"
			physics_material_override.friction = 1
	
			if abs(linear_velocity.x) > 10:
				$AnimatedSprite.animation = "SlidingFloor"
		
			$CustomSprite.rotation_degrees = 0
		
		checkFinished()
	
	else:
		
		$AnimatedSprite.speed_scale = 1.5 * abs(linear_velocity.y) / 200
		
		if linear_velocity.y <= 0:
			$AnimatedSprite.animation = "Jumping"
		elif linear_velocity.y > 0:
			$AnimatedSprite.animation = "Falling"
			
		if is_on_left_wall():
			$AnimatedSprite.animation = "SlidingWall"
			$AnimatedSprite.flip_h = false
			
		elif is_on_right_wall():
			$AnimatedSprite.animation = "SlidingWall"
			$AnimatedSprite.flip_h = true
			
	if x > 0:
		$AnimatedSprite.flip_h = false
	elif x < 0:
		$AnimatedSprite.flip_h = true
		
	$CustomSprite.flip_h = $AnimatedSprite.flip_h
	
	var rotation_dir = 1
	if $CustomSprite.flip_h == true:
		rotation_dir = -1
	
	if not is_on_right_wall() and not is_on_left_wall() and not is_on_floor():
		$CustomSprite.rotation_degrees += CUSTOM_SPRITE_ROTATION_SPEED * rotation_dir * 1.5
#		if linear_velocity.y < 0:
#			pass
#			$CustomSprite.rotation_degrees += CUSTOM_SPRITE_ROTATION_SPEED * rotation_dir 
#			$CustomSprite.rotation_degrees *= abs(linear_velocity.y) / 300
#		elif linear_velocity.y > 0:
#			CustomSprite.rotation_degrees += CUSTOM_SPRITE_ROTATION_SPEED * rotation_dir * 1.5
#			$CustomSprite.rotation_degrees *= abs(linear_velocity.y) / 1000
		
## Helper functions
# Gets if the center jump zone detects a floor (player is definitely on a floor)
func is_on_floor():
	return !center_zone.get_overlapping_bodies().empty()
# Gets if the wide bottom jump zone detects a floor (player might be on floor or just off a ledge)
func is_maybe_on_floor():
	return !bottom_zone.get_overlapping_bodies().empty()
func is_on_left_wall():
	return !left_zone.get_overlapping_bodies().empty()
func is_on_right_wall():
	return !right_zone.get_overlapping_bodies().empty()



func _integrate_forces(state):
	if resetPosNextFrame:
		var xform = state.get_transform()
		xform.origin.x = startPos.x
		xform.origin.y = startPos.y
		state.set_transform(xform)
		resetPosNextFrame = false
		dead = false

	
func resetPosition():
	resetPosNextFrame = true


func test():
	print('Test')


# See if we've completed the level
func checkFinished():
	if finished:
		return
	
	var overlap = center_zone.get_overlapping_bodies()
	for body in overlap:
		if body.name == 'EndBlock':
			emit_signal("finished")
			finished = true
			finishTimer.start()
			break


# See if we've fallen off the edge
func checkFell():
	if deathNode != null:
		if position.y > deathNode.position.y:
			Globals.GM.die()
			return true
	return false


func _on_GameManager_switchMode(mode):
	if mode == Globals.Modes.PLAYING:
		resetPosition()
		$Camera2D.make_current()


func _on_Timer_timeout():
	finished = false


func change_sprite():
	CUSTOM_SPRITE_NUM = Globals.playerSprites[CURRENT_PLAYER-1]
	
	if CUSTOM_SPRITE_NUM == 0:
		$CustomSprite.visible = false
		$AnimatedSprite.visible = true
	
	else:
		$CustomSprite.visible = true
		$AnimatedSprite.visible = false
		$CustomSprite.texture = Globals.customSprites[CUSTOM_SPRITE_NUM-1]


var wobble_dir = 1
func wobble_sprite():
	if $CustomSprite.rotation_degrees > WOBBLE:
		$CustomSprite.rotation_degrees = WOBBLE
		wobble_dir = -1
	elif $CustomSprite.rotation_degrees < -WOBBLE:
		$CustomSprite.rotation_degrees = -WOBBLE
		wobble_dir = 1
	$CustomSprite.rotation_degrees += GROUND_WOBBLE_SPEED * wobble_dir * abs(linear_velocity.x) / HORIZONTAL_MAX_SPEED
