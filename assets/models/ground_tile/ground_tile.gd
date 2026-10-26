@tool
extends StaticBody3D
class_name GroundTile

@onready var top_part: MeshInstance3D = $TopPart
@onready var bottom_part: MeshInstance3D = $BottomPart

@export var top_material: StandardMaterial3D = null:
	set(value):
		top_material = value
		if is_node_ready(): update_parts_material()
@export var bottom_material: StandardMaterial3D = null:
	set(value):
		bottom_material = value
		if is_node_ready(): update_parts_material()

func _ready() -> void: update_parts_material()

func update_parts_material() -> void:
	top_part.material_override = top_material
	bottom_part.material_override = bottom_material
