extends Node2D

export var fric: float


func _ready():
	$Block.physics_material_override.friction = fric

