extends Area3D
class_name Obstacle

signal player_touched

enum TYPES {
	BALL,
	WALL,
	LONG
}

const MATERIAL: StandardMaterial3D = preload("res://assets/materials/transparent_blue_material.tres")

var _obstacle_data: LineLevelObstacle = null

var small_size: Vector3 = Vector3(0.01, 0.01, 0.01)
var normal_size: Vector3 = Vector3(1.0, 1.0, 1.0)
var size_tween

func set_obstacle(obstacle_data: LineLevelObstacle) -> void:
	_obstacle_data = obstacle_data
	setup_obstacle()
	popup()

func popup() -> void:
	if size_tween: size_tween.kill()
	size_tween = get_tree().create_tween()
	
	scale = small_size
	size_tween.tween_property(
		self, "scale",
		normal_size, 3.0
	)

func _create_mesh_instance(mesh: Mesh) -> MeshInstance3D:
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	mesh_instance.name = "MeshInstance"
	mesh_instance.mesh = mesh
	mesh_instance.material_override = MATERIAL
	
	return mesh_instance

func _create_collision_shape(shape: Shape3D) -> CollisionShape3D:
	var collision_shape: CollisionShape3D = CollisionShape3D.new()
	collision_shape.name = "CollisionShape"
	collision_shape.shape = shape
	
	return collision_shape

func setup_obstacle() -> void:
	if not _obstacle_data: return
	
	match _obstacle_data.type:
		TYPES.BALL: call_deferred("_set_ball_obstacle", _obstacle_data.value)
		TYPES.WALL: call_deferred("_set_wall_obstacle", _obstacle_data.value)
		TYPES.LONG: call_deferred("_set_long_obstacle", _obstacle_data.value)

func _set_ball_obstacle(radius: float) -> void:
	# Create the mesh
	var sphere_mesh: SphereMesh = SphereMesh.new()
	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2
	add_child(_create_mesh_instance(sphere_mesh))
	# Create the shape for collisions
	var sphere_shape: SphereShape3D = SphereShape3D.new()
	sphere_shape.radius = radius
	add_child(_create_collision_shape(sphere_shape))

func _set_wall_obstacle(lenght: float) -> void:
	# Create the mesh
	var box_mesh: BoxMesh = BoxMesh.new()
	box_mesh.size = Vector3(
		1.5, 50.0,
		lenght
	)
	add_child(_create_mesh_instance(box_mesh))
	# Create the shape for collisions
	var box_shape: BoxShape3D = BoxShape3D.new()
	box_shape.size = Vector3(
		1.5, 50.0, 1.0
	)
	var collision_shape: CollisionShape3D = _create_collision_shape(box_shape)
	collision_shape.position.z = -(lenght/2)
	add_child(collision_shape)

func _set_long_obstacle(width: float) -> void:
	# Create the mesh
	var box_mesh: BoxMesh = BoxMesh.new()
	box_mesh.size = Vector3(
		width, 1.0, 5.0
	)
	add_child(_create_mesh_instance(box_mesh))
	# Create the shape for collisions
	var box_shape: BoxShape3D = BoxShape3D.new()
	box_shape.size = Vector3(
		1.0, 1.0, 5.0
	)
	var collision_shape: CollisionShape3D = _create_collision_shape(box_shape)
	collision_shape.position.x = -(width/2)
	add_child(collision_shape)

func _on_body_entered(body: Node3D) -> void:
	if body is LinesLevelPlayer: player_touched.emit()
