extends Area2D
class_name DraggableTile


var mouseOffset
var following := false
var canDrag := false
var canPlace := true
var collision
var startPos: Vector2
var draggedChild
var childResourcePath = "res://Prefabs/Block.tscn"
var childResourceScaling := 1.0

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
	
	mouseOffset = tileMap.cell_size / 2
	
	if Globals.GM.currMode == Globals.Modes.BUILDING:
		switchModeBuilding()
	
	get_tree().current_scene.get_node("GameManager").connect('switchMode', self, '_on_switchMode')
	get_tree().current_scene.get_node("GameManager").connect('switchPlayer', self, '_on_switchPlayer')


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
			pickupTile()
			

func _input(event):
	# Release and put on world
	if event.is_action_released("click"):
		if following:
			following = false
			placeTile()


# Update position to snap to grid
func followMouse():
	position = tileMap.map_to_world(tileMap.world_to_map(get_global_mouse_position()))
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
	
	draggedChild.enabled = true
	draggedChild.set_physics_process(true)
	
	if draggedChild is RigidBody2D:
		print('rigid')
		draggedChild.gravity_scale = 1
	
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
		print('rigid')
		draggedChild.gravity_scale = 0
	
	draggedChild.enabled = false
	draggedChild.set_physics_process(false)
	
	canDrag = true
