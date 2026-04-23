extends StaticBody3D
class_name Map_Player

@onready var camera: Camera3D = $Camera
@onready var map: MeshInstance3D = $Arm/Map
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	GameManager.look_at_map_changed.connect(
		func():
			if GameManager.look_at_map: animation_player.play("yes_look_map")
			else: animation_player.play("not_look_map")
	)
	map.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_action_just_pressed("ToggleMap"):
		if not animation_player.is_playing(): GameManager.look_at_map = not(GameManager.look_at_map)
	if event is InputEventMouseMotion and not GameManager.look_at_map: _rotate()

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
