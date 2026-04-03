extends StaticBody3D
class_name Map_Player

@onready var camera: Camera3D = $Camera

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: _rotate()

func _rotate() -> void:
	var viewport: Viewport = get_viewport()
	var mouse_position: Vector2 = viewport.get_mouse_position()
	
	var origin: Vector3 = camera.project_ray_origin(mouse_position)
	var direction: Vector3 = camera.project_ray_normal(mouse_position)
	
	var ray_length: float = camera.far
	var end: Vector3 = origin + direction * ray_length
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result.has("position"):
		look_at(result.position / 1.05)
		
		rotation_degrees.x = clampf(rotation_degrees.x, 0.0, 10.0)
		rotation_degrees.y = clampf(rotation_degrees.y, -50.0, 50.0)
		#camera.fov = clampf(camera.fov, 115.0, 130.0)
