extends Area2D


export(NodePath) var tileMapNP: NodePath
onready var tileMap = get_node(tileMapNP)
onready var mouseOffset = $CollisionShape2D.shape.extents;

var following: bool = false
var startPos: Vector2
var kinematicChild: CollisionShape2D

func _ready():
	startPos = position


func _physics_process(delta):
	if following:
		followMouse()


func _input_event(viewport, event, shape_idx):
	# Start dragging
	if event.is_action_pressed("click"):
		if event.is_pressed():
			following = true
			$KinematicBody2D.remove_child(kinematicChild)
	# Release and put on tilemap
	elif event.is_action_released("click"):
		if following:
			following = false
			placeTile()


# Update position to snap to grid
func followMouse():
	position = tileMap.map_to_world(tileMap.world_to_map(get_global_mouse_position()))
	position += mouseOffset


# Places tile at current location
func placeTile():
	var tilePos = tileMap.world_to_map(position)
	var tileType = 0
	kinematicChild = $CollisionShape2D.duplicate()
	$KinematicBody2D.add_child(kinematicChild)
	kinematicChild.position = Vector2.ZERO
#	tileMap.set_cellv(tilePos, tileType)
	
	# DEBUG Reset tile to original position
#	position = startPos
