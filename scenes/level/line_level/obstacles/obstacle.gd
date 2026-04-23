extends Area3D
class_name Obstacle

enum TYPES {
	BALL,
	WALL
}

@export var obstacle_data: LineLevelObstacle = null:
	set(value):
		obstacle_data = value
		setup_obstacle()

func _create_mesh_instance(mesh: Mesh) -> MeshInstance3D:
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	mesh_instance.name = "MeshInstance"
	mesh_instance.mesh = mesh
	mesh_instance.material_override = load("res://assets/materials/transparent_blue_material.tres")
	
	return mesh_instance

func _create_collision_shape(shape: Shape3D) -> CollisionShape3D:
	var collision_shape: CollisionShape3D = CollisionShape3D.new()
	collision_shape.name = "CollisionShape"
	collision_shape.shape = shape
	
	return collision_shape

func setup_obstacle() -> void:
	if not obstacle_data: return
	
	match obstacle_data.type:
		TYPES.BALL: call_deferred("_set_ball_obstacle", obstacle_data.value)
		TYPES.WALL: call_deferred("_set_wall_obstacle", obstacle_data.value)

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
		1.5, 5.0,
		lenght
	)
	add_child(_create_mesh_instance(box_mesh))
	# Create the shape for collisions
	var box_shape: BoxShape3D = BoxShape3D.new()
	box_shape.size = Vector3(
		1.5, 5.0, 1.0
	)
	var collision_shape: CollisionShape3D = _create_collision_shape(box_shape)
	collision_shape.position.z = -(lenght/2)
	add_child(collision_shape)
