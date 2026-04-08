extends Node3D

@onready var sections: Node3D = $Sections
@onready var merging_meshes: MeshInstance3D = $MergingMeshes

var meshes_nodes: Array[MeshInstance3D] = []

func _ready() -> void:
	list_meshes_nodes_at(sections)
	var merged_array_mesh: ArrayMesh = merging_meshes.merge_multiple_meshes(meshes_nodes)
	
	var merged_mesh_instance: MeshInstance3D = MeshInstance3D.new()
	merged_mesh_instance.name = "MergedMeshInstance"
	add_child(merged_mesh_instance)
	merged_mesh_instance.mesh = merged_array_mesh

func list_meshes_nodes_at(node: Node) -> void:
	for child: Node in node.get_children():
		if child is MeshInstance3D: meshes_nodes.append(child)
		
		if child.get_child_count() > 0: list_meshes_nodes_at(child)
