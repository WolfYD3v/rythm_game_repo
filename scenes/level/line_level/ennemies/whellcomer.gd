extends Node3D

@export var rotation_value: float = -100
@export var min_rot_random_value: float = -20.0
@export var max_rot_random_value: float = 20.0

func _ready() -> void:
	await get_tree().create_timer(3.5).timeout
	rotate_body_part(get_child(0).get_child(0), rotation_value, false)

func rotate_body_part(body_part: Node3D, rot: float, is_random: bool) -> void:
	if is_random: rot = randf_range(min_rot_random_value, max_rot_random_value)
	
	for loop in range(15):
		body_part.rotate_z(deg_to_rad(rot / 15))
		await get_tree().create_timer(0.02).timeout
	
	if body_part.get_child_count() == 1:
		await get_tree().create_timer(0.03).timeout
		call_deferred(
			"rotate_body_part", body_part.get_child(0),
			rot, is_random
		)
		#rotate_body_part(body_part.get_child(0), rot, is_random)
