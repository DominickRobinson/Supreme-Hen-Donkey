extends Node2D

export var fric: float

var enabled := true
onready var dragCollider = $Block/CollisionShape2D

func _ready():
	$Block.physics_material_override.friction = fric

