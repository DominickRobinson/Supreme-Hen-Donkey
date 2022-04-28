extends Area2D
class_name DraggableTile

const blockBuffer := 3
const rotateSteps := 10
var blockBufferPx

var mouseOffset
var following := false
var canDrag := false
var canPlace := true
var collision
var startPos: Vector2
var draggedChild
var rotatedBy := 0

var childResourcePath = "res://Prefabs/Block.tscn"
var childResourceScaling := 1.0
var startBlock
var endBlock

onready var tileMap = get_tree().current_scene.get_node('TileMap')


func _ready():
	startPos = position
	
	# Load kinematic body
	draggedChild = load(childResourcePath).instance()
	draggedChild.enabled = false
	add_child(draggedChild)
	
	# Add collision shape and do some transformations to make it rectified
	draggedChild.scale *= Vector2(childResourceScaling, childResourceScaling)
	collision = draggedChild.dragCollider.duplicate()
	collision.transform = collision.transform.rotated(draggedChild.dragCollider.get_global_transform().get_rotation())
	collision.scale = draggedChild.dragCollider.get_global_transform().get_scale()
	collision.position *= collision.scale
	
	collision.visible = true
	
	# Editor dragging
	mouseOffset = tileMap.cell_size / 2
	blockBufferPx = blockBuffer * tileMap.cell_size[0]
	
	if Globals.GM.currMode == Globals.Modes.BUILDING:
		switchModeBuilding()
	
	get_tree().current_scene.get_node("GameManager").connect('switchMode', self, '_on_switchMode')
	get_tree().current_scene.get_node("GameManager").connect('switchPlayer', self, '_on_switchPlayer')


func init(childResourcePath, childResourceScaling, startBlock, endBlock):
	self.childResourcePath = childResourcePath
	self.childResourceScaling = childResourceScaling
	self.startBlock = startBlock
	self.endBlock = endBlock


func _physics_process(delta):
	if following:
		followMouse()


func _input_event(viewport, event, shape_idx):
	if !canPlace:
		return
		
	# Start dragging when clicked on
	if event.is_action_pressed("click"):
		if event.is_pressed() && canDrag:
			following = true
			Globals.GM.builderView.draggingTile = true
			pickupTile()
			

func _input(event):
	# Release and put on world
	if event.is_action_released("click"):
		if following:
			following = false
			Globals.GM.builderView.draggingTile = false
			placeTile()
	
	if following:
		if event.is_action_released('wheel_down'):
			rotate(-1)
		elif event.is_action_released('wheel_up'):
			rotate(+1)


# Update position to snap to grid
func followMouse():
	var newPos = tileMap.map_to_world(tileMap.world_to_map(get_global_mouse_position()))
	if (newPos.distance_to(startBlock.position) > blockBufferPx) && \
		(newPos.distance_to(endBlock.position) > blockBufferPx):
		position = newPos
		position += mouseOffset


func pickupTile():
	Globals.GM.changeParentage(self)
#	draggedChild.remove_child(collision)


# Places tile at current location
func placeTile():
	pass


# Gets the collidable node, that we drag
func getCollidable(obj):
	for child in obj.get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			return child


func _on_switchMode(mode):
	match mode:
		Globals.Modes.PLAYING:
			switchModePlaying()
		
		Globals.Modes.BUILDING:
			switchModeBuilding()


func _on_switchPlayer(player):
	# When the player switches, lock in the position
	canPlace = false


func switchModePlaying():
	collision.position = Vector2.ZERO
	remove_child(collision)
	
	var oldPos = position
	Globals.GM.changeParentage(draggedChild)
	draggedChild.position = oldPos
	draggedChild.rotation += rotation
	
	draggedChild.enabled = true
	draggedChild.set_physics_process(true)
	draggedChild.set_process(true)
	
	if draggedChild is RigidBody2D:
		draggedChild.gravity_scale = 1
		for bit in [0, 1]:
			draggedChild.set_collision_layer_bit(bit, true)
			draggedChild.set_collision_mask_bit(bit, true)
	
	canDrag = false
	canPlace = false


func switchModeBuilding():
	# Reset kinematic child if we're already in the world
	if !canPlace:
		draggedChild.queue_free()
		draggedChild = load(childResourcePath).instance()
		add_child(draggedChild)
		draggedChild.scale *= Vector2(childResourceScaling, childResourceScaling)
	else:
		draggedChild.position = Vector2.ZERO
		add_child(collision)
	
	if draggedChild is RigidBody2D:
		draggedChild.gravity_scale = 0
		for bit in [0, 1]:
			draggedChild.set_collision_layer_bit(bit, false)
			draggedChild.set_collision_mask_bit(bit, false)
			
	draggedChild.enabled = false
	draggedChild.set_physics_process(false)
	draggedChild.set_process(false)
	
	canDrag = true


# Rotates by the number of steps
func rotate(steps):
	rotatedBy = (rotatedBy + steps) % rotateSteps
	
	rotation = rotatedBy * 2*PI/rotateSteps








