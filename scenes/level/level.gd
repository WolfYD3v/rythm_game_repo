extends Node3D
class_name Level

@onready var world: Node3D = $World
@onready var obstacles: Node3D = $Obstacles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func build_level() -> void:
	pass
