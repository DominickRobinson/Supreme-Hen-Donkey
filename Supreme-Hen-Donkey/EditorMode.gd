extends Node2D

onready var tilemap = $TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var tileMap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _input(event):
	# Mouse in viewport coordinates.
	if event.is_action_pressed("place_tile"):
		var tilePos = tileMap.world_to_map(get_global_mouse_position())
		tileMap.set_cellv(tilePos, 0)
	

   # Print the size of the viewport.
#   print("Viewport Resolution is: ", get_viewport_rect().size)
