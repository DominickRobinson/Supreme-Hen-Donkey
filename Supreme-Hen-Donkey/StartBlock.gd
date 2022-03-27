extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var offset

# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = $CollisionShape2D.shape
	offset = Vector2(0, shape.extents.y)


func _on_GameManager_switchMode(mode):
	if mode == Globals.Modes.PLAYING:
		var player = get_node('../Player/')
		player.resetPosition(position+offset)
