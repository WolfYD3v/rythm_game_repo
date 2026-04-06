extends Node3D
class_name Hoyploma

@onready var top_camera: Camera3D = $TopCamera
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera
@onready var building: Node3D = $Building

@export var top_camera_view: bool = false
@export_range(0.05, 0.2, 0.05) var camera_rotation_speed: float = 0.1

const NEW_TSCN_RESOURCE_PATH: String = "user://hoyploma.tscn"

func _ready() -> void:
	top_camera.current = top_camera_view
	SceneManager.replacing_scene.connect(pack_scene)

func _physics_process(delta: float) -> void:
	camera_pivot.rotate_y(camera_rotation_speed * delta)
	camera.look_at_from_position(
		camera.global_position,
		building.global_position
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
