extends Area2D


export(NodePath) var tileMapNP: NodePath
onready var tileMap = get_node(tileMapNP)

var mouseOffset
var following: bool = false
var collision: CollisionShape2D
var startPos: Vector2
var kinematicChild: KinematicBody2D

func _ready():
	startPos = position
	# Get kinematic child
	for child in get_children():
		if child is KinematicBody2D:
			kinematicChild = child
			break
	
	collision = kinematicChild.get_node('CollisionShape2D')
	add_child(collision.duplicate())
	kinematicChild.remove_child(collision)
	
	mouseOffset = collision.shape.extents


func _physics_process(delta):
	if following:
		followMouse()


func _input_event(viewport, event, shape_idx):
	# Start dragging
	if event.is_action_pressed("click"):
		if event.is_pressed():
			print('Click')
			following = true
			pickupTile()
			
	# Release and put on tilemap
	elif event.is_action_released("click"):
		if following:
			following = false
			placeTile()


# Update position to snap to grid
func followMouse():
	position = tileMap.map_to_world(tileMap.world_to_map(get_global_mouse_position()))
	position += mouseOffset


func pickupTile():
	kinematicChild.remove_child(collision)


# Places tile at current location
func placeTile():
	var tilePos = tileMap.world_to_map(position)
	var tileType = 0
	kinematicChild.add_child(collision)
	collision.position = Vector2.ZERO
	kinematicChild.enabled = true
	
	# DEBUG Reset tile to original position
#	position = startPos
