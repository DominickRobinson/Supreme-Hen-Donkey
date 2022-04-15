extends RigidBody2D

onready var startBlock = get_tree().current_scene.get_node('StartBlock')
onready var endBlock = get_tree().current_scene.get_node('EndBlock')

const draggableTile = preload("res://Prefabs/DraggableTile.tscn")

export(Array, String, FILE) var possibleTiles
export(Array, float) var tileScalings

export var VELOCITY := 800.0

var limits = Rect2()
var maxZoom: float
var startPos: Vector2
var resetPosNextFrame := false


func _ready():
	var buffer = 150
	
	# Set bounds we can move
	var limit_left = min(startBlock.position.x, endBlock.position.x) - buffer
	var limit_right = max(startBlock.position.x, endBlock.position.x) + buffer
	var limit_bottom = max(startBlock.position.y, endBlock.position.y) + buffer
	var limit_top = min(startBlock.position.y, endBlock.position.y) - buffer
	
	limits.position = Vector2(limit_left, limit_top)
	limits.end = Vector2(limit_right, limit_bottom)
	startPos = limits.position + 0.5*limits.size
	maxZoom = getMaxZoom()
	
	resetPosition()
	
	Globals.GM.connect("switchMode", self, "_on_GameManager_switchMode")
	Globals.GM.connect("switchPlayer", self, "_on_GameManager_switchPlayer")


func getMaxZoom():
#	var view_size = get_viewport_rect().size / ctrans.get_scale()
	
	# Get scaling necessary to encompass entire limits
	var bothScales = limits.size / get_viewport_rect().size
	bothScales = bothScales.snapped(0.25*Vector2.ONE)
	
	# Return maximum of the scales
	return max(bothScales[0], bothScales[1])


func _physics_process(_delta: float):
	var x := Input.get_action_strength("right") - Input.get_action_strength("left")
	var y := Input.get_action_strength("down") - Input.get_action_strength("up")
	
	var velocity = VELOCITY*$BuilderViewCam.zoom.x
	linear_velocity = Vector2.ZERO
	
	if (x < 0 && limits.position.x < position.x) || (x > 0 && position.x < limits.end.x):
		 linear_velocity.x = x*velocity
	
	# Within y bounds, move
	if (y < 0 && limits.position.y < position.y) || (y > 0 && position.y < limits.end.y):
		 linear_velocity.y = y*velocity


func _integrate_forces(state):
	if resetPosNextFrame:
		var xform = state.get_transform()
		xform.origin.x = startPos.x
		xform.origin.y = startPos.y
		state.set_transform(xform)
		resetPosNextFrame = false


func _input(event):
	# Zoom
	if event.is_action_released('wheel_down') and $BuilderViewCam.zoom.x < maxZoom:
		$BuilderViewCam.zoom.x += 0.25
		$BuilderViewCam.zoom.y += 0.25
	
	elif event.is_action_released('wheel_up') and $BuilderViewCam.zoom.x > 1:
		$BuilderViewCam.zoom.x -= 0.25
		$BuilderViewCam.zoom.y -= 0.25


func _on_GameManager_switchPlayer(player):
	if Globals.GM.currMode == Globals.Modes.BUILDING:
		# Destroy any draggable children left in the bank
		for child in get_children():
			if child is DraggableTile:
				child.queue_free()
				
		respawnDraggables()


# Resets position on switch mode
func _on_GameManager_switchMode(mode):
	resetPosition()


# Centers and zooms out as much as possible
func resetPosition():
	$BuilderViewCam.zoom.x = maxZoom
	$BuilderViewCam.zoom.y = maxZoom
	resetPosNextFrame = true


# Spawn a new block when we're in build mode
func respawnDraggables():
	# Spawn draggable tile
	var obj = draggableTile.instance()
	obj.position = Vector2(0, -250)
	
	# Get random object to place inside the tile
	var i = Globals.rng.randi() % possibleTiles.size()
#	i = 4
	obj.childResourcePath = possibleTiles[i]
	obj.childResourceScaling = tileScalings[i]
	# Add to the world
	add_child(obj)












