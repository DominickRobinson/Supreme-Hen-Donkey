extends Node2D

onready var tilemap_rect = Rect2(-100, -100, 200, 200) #get_parent().get_used_rect()
onready var tilemap_cell_size = get_parent().cell_size
onready var color = Color(0.0, 1.0, 0.0)

func _ready():
	visible = false
	Globals.GM.connect("switchMode", self, "_on_GameManager_switchMode")
	set_process(true)


func _process(delta):
	update()


func _draw():
	for y in range(tilemap_rect.position.y, tilemap_rect.end.y):
		draw_line(Vector2(tilemap_rect.position.x*tilemap_cell_size.x, y*tilemap_cell_size.y), Vector2(tilemap_rect.end.x*tilemap_cell_size.x, y*tilemap_cell_size.y), color)

	for x in range(tilemap_rect.position.x, tilemap_rect.end.x):
		draw_line(Vector2(x*tilemap_cell_size.x, tilemap_rect.position.y*tilemap_cell_size.y), Vector2(x*tilemap_cell_size.x, tilemap_rect.end.y*tilemap_cell_size.y), color)


# Draws on switch mode
func _on_GameManager_switchMode(mode):
	visible = mode == Globals.Modes.BUILDING
