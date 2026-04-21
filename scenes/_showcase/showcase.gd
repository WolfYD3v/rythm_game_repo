extends Node3D
class_name Showcase

@onready var showcase_spot: Node3D = $ShowcaseSpot
@onready var camera_center_rot_marker_3d: Marker3D = $CameraCenterRotMarker3D

@export var showcase_packed_scene: PackedScene = null
@export var camara_rotate: bool = true

func _ready() -> void:
	if showcase_packed_scene: showcase_spot.add_child(
		showcase_packed_scene.instantiate()
	)

func _process(_delta: float) -> void:
	if showcase_packed_scene and camara_rotate: camera_center_rot_marker_3d.rotate_y(
		deg_to_rad(0.5)
	)
