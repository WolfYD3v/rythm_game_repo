extends Node3D
class_name Hoyploma

@onready var camera: Camera3D = $Camera
@onready var building: Node3D = $Building

@export_range(0.1, 0.2, 0.1, "or_greater", "hide_control") var camera_rotation_speed: float = 5.0

const NEW_TSCN_RESOURCE_PATH: String = "user://hoyploma.tscn"

func _ready() -> void:
	SceneManager.replacing_scene.connect(pack_scene)
	
	var temp_camera_tween = get_tree().create_tween()
	temp_camera_tween.tween_property(
		camera, "global_position",
		camera.global_position + Vector3(
			15,
			-8,
			22
		),
		10.0
	)

func _physics_process(_delta: float) -> void:
	camera.look_at_from_position(
		camera.global_position,
		building.global_position,
	)

func pack_scene() -> void:
	for child in get_children(): child.owner = self
	
	var scene: PackedScene = PackedScene.new()
	var result = scene.pack(self)
	if result == OK:
		var error = ResourceSaver.save(scene, NEW_TSCN_RESOURCE_PATH)
		if error == OK:
			SceneManager.remove_scene("Hoyploma")
			SceneManager.add_scene("Hoyploma", load(NEW_TSCN_RESOURCE_PATH))
		else: push_error("An error occurred while saving the scene to disk.")
