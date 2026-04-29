extends Node3D
class_name BoxyThing

@onready var box_door_rot_node_3d: Node3D = $BoxDoorRotNode3D

@export var locked: bool = false
@export var opened: bool = false

var rot_tween

func _ready() -> void:
	if locked: opened = false
	if opened: open()
	else: close()

func set_opened(value: bool) -> void:
	opened = value
	_ready()

func open() -> void:
	if not locked:
		print("Opening box...")
		_tween_rot(-90.0)

func close() -> void:
	print("Closing box...")
	_tween_rot(0.0)

func _tween_rot(value: float) -> void:
	if rot_tween: rot_tween.kill()
	rot_tween = get_tree().create_tween()
	rot_tween.tween_property(
		box_door_rot_node_3d, "rotation:x",
		deg_to_rad(value), 1.5
	)
