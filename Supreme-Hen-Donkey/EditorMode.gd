extends Node2D


export(NodePath) var tileMapNP: NodePath
onready var tileMap = get_node(tileMapNP)

func _ready():
	pass


func _input(event):
#	if event.is_action_pressed("debug1"):
#		placeTiles()
	pass


func placeTiles():
	for node in get_children():
		node.placeTile()
