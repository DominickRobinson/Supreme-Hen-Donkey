extends Node2D
class_name Eraser

var enabled := true

onready var dragCollider = $StaticBody2D/CollisionPolygon2D

var toErase = []

func _ready():
	pass


func erase():
	for node in toErase:
		node.queue_free()
	
	queue_free()
