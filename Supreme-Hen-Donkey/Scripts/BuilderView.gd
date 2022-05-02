extends RigidBody2D

onready var startBlock = get_tree().current_scene.get_node('StartBlock')
onready var endBlock = get_tree().current_scene.get_node('EndBlock')

const draggableTile = preload("res://Prefabs/DraggableTile.tscn")

export(Array, String, FILE) var possibleTiles
export(Array, float) var tileScalings
var tileWeights = [1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.25, 0.25, 0.5, 2]

export var VELOCITY := 800.0

var erasableTileNames = []
var limits = Rect2()
var maxZoom: float
var startPos: Vector2
var resetPosNextFrame := false
var draggingTile := false
var wasRigid := false
var totalTileWeights := 0


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
	
	# Get loot table
	totalTileWeights = sum_array(tileWeights)
	
	Globals.UI.get_node('Bank').getTilePos()
	resetPosition()
	respawnDraggables()
	
	# Things that can be erased
	for node in possibleTiles:
		erasableTileNames.append(load(node).instance().name)
	
	# Signals
	Globals.GM.connect("switchMode", self, "_on_GameManager_switchMode")
	Globals.GM.connect("switchPlayer", self, "_on_GameManager_switchPlayer")


static func sum_array(array):
	var sum = 0.0
	for element in array:
		 sum += element
	return sum


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
	#var velocity = VELOCITY*$BuilderViewCam.zoom.x + VELOCITY*$BuilderViewCam.zoom.y
	linear_velocity = Vector2.ZERO
	
	linear_velocity.x = x*velocity
	linear_velocity.y = y*velocity
	
#	if (x < 0 && limits.position.x < position.x) || (x > 0 && position.x < limits.end.x):
#		 linear_velocity.x = x*velocity
#
#	# Within y bounds, move
#	if (y < 0 && limits.position.y < position.y) || (y > 0 && position.y < limits.end.y):
#		 linear_velocity.y = y*velocity
	
	# Force rigid bodies to keep up
	if (linear_velocity != Vector2.ZERO):
		for child in get_children():
			if (child is DraggableTile) and (child.draggedChild is RigidBody2D):
				child.draggedChild.mode = RigidBody2D.MODE_KINEMATIC
				child.draggedChild.position = Vector2.ZERO
				wasRigid = true


func _integrate_forces(state):
	if resetPosNextFrame:
		var xform = state.get_transform()
		xform.origin.x = startPos.x
		xform.origin.y = startPos.y
		state.set_transform(xform)
		resetPosNextFrame = false


func _input(event):
	# Zoom
	if event.is_action_released('wheel_down') and $BuilderViewCam.zoom.x < maxZoom and !draggingTile:
		$BuilderViewCam.zoom.x += 0.25
		$BuilderViewCam.zoom.y += 0.25
	
	elif event.is_action_released('wheel_up') and $BuilderViewCam.zoom.x > 1 and !draggingTile:
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
	wasRigid = false


# Centers and zooms out as much as possible
func resetPosition():
	$BuilderViewCam.zoom.x = maxZoom
	$BuilderViewCam.zoom.y = maxZoom
	resetPosNextFrame = true


# Spawn a new block when we're in build mode
func respawnDraggables():
	for tileNum in range(3):
		# Spawn draggable tile
		var dragTileObj = draggableTile.instance()
		var dragX = Globals.UI.get_node('Bank').tileX[tileNum]
		var dragY = Globals.UI.get_node('Bank').tileY
		var dragPos = Vector2(dragX, dragY) + Vector2(-1000, 0)
		dragTileObj.position = Vector2(dragPos.x, dragPos.y) #Vector2(0, -250)
		
		# Get random dragTileObj to place inside the tile
		if possibleTiles.size() > 0:
			var amountBy = (Globals.rng.randi() / 4294967295.0) * totalTileWeights
			var i = 0
			for j in range(possibleTiles.size()):
				if amountBy <= tileWeights[j]:
					i = j
					break
				amountBy -= tileWeights[j]
			
#			var i = Globals.rng.randi() % possibleTiles.size()
#			if Globals.rng.randi() % 2 == 0:
#				i = -1
			dragTileObj.init(possibleTiles[i], tileScalings[i], Globals.GM.startBlock, Globals.GM.endBlock)
		
		# Add to the world
		add_child(dragTileObj)


# Removes all tiles in the bank
func clearTiles():
	for child in get_children():
		if (child is DraggableTile) and (child.insideBank):
			child.queue_free()






