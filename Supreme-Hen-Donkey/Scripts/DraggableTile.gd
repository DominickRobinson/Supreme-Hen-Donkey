extends Area2D


export(NodePath) var tileMapNP: NodePath
onready var tileMap = get_node(tileMapNP)

var mouseOffset
var following := false
var canDrag := false
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
#	add_child(collision.duplicate())
#	kinematicChild.remove_child(collision)
	
	mouseOffset = tileMap.cell_size / 2
	
	get_node("../GameManager/").connect('switchMode', self, '_on_switchMode')


func _physics_process(delta):
	if following:
		followMouse()


func _input_event(viewport, event, shape_idx):
	# Start dragging when clicked on
	if event.is_action_pressed("click"):
		if event.is_pressed() && canDrag:
			print(canDrag)
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
	pass
#	kinematicChild.remove_child(collision)


# Places tile at current location
func placeTile():
	pass
#	var tilePos = tileMap.world_to_map(position)
#	var tileType = 0
#	kinematicChild.add_child(collision)
#	collision.position = Vector2.ZERO


func _on_switchMode(mode):
	match mode:
		Globals.Modes.PLAYING:
			switchModePlaying()
		
		Globals.Modes.BUILDING:
			switchModeBuilding()


func switchModePlaying():
	collision.position = Vector2.ZERO
	
	kinematicChild.add_child(collision)
	remove_child(get_node('CollisionShape2D'))
	kinematicChild.enabled = true
	
	canDrag = false


func switchModeBuilding():
	kinematicChild.position = Vector2.ZERO
	
	collision = kinematicChild.get_node('CollisionShape2D')
	add_child(collision.duplicate())
	kinematicChild.remove_child(collision)
	kinematicChild.enabled = false
	
	canDrag = true
