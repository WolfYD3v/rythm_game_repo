extends Node3D
class_name LevelStone

@onready var gameplay_icon_mesh: MeshInstance3D = $GameplayIconMesh
@onready var pos_marker_3d: Marker3D = $PosMarker3D

@export var level_packed_scene: PackedScene = null
@export var locked: bool = false
@export var song_data: SongData = null
@export var sample_start: float = 0.0
@export_range(5.0, 10.0, 0.1, "prefer_slider") var sample_duration: float = 5.0
enum GAMEPLAY_TYPES {
	LINES,
	BOSS_FIGHT
}
@export var gameplay_type: GAMEPLAY_TYPES = GAMEPLAY_TYPES.LINES
@export_range(1, 15, 1, "prefer_slider") var difficulty: int = 1

const LINE_LEVEL = preload("res://scenes/level/line_level/line_level.tscn")

func _ready() -> void:
	set_gameplay_type_icon()

func set_gameplay_type_icon() -> void:
	var icon_path: String = ""
	match gameplay_type:
		GAMEPLAY_TYPES.LINES: icon_path = "res://WolfY_D3vPP.jpeg"
		GAMEPLAY_TYPES.BOSS_FIGHT: icon_path = "res://icon.svg"
	
	# Load the related icon of the gameplay
	if icon_path != "":
		var gameplay_icon_mesh_material: StandardMaterial3D = gameplay_icon_mesh.get_surface_override_material(0).duplicate()
		gameplay_icon_mesh_material.albedo_texture = load(icon_path)
		gameplay_icon_mesh.set_surface_override_material(0, gameplay_icon_mesh_material)

func get_pos_marker_position() -> Vector3:
	return pos_marker_3d.global_position

func _on_play_button_pressed() -> void:
	if locked or not level_packed_scene: return
	
	#stop_music_sample()
	LevelManager.go_to_level(level_packed_scene)

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		GuisManager.gui_call_method("LevelStoneGUI", "setup", [
			song_data, sample_start, difficulty, locked
		])
		GuisManager.show_gui("LevelStoneGUI")
		GuisManager.gui_call_method("LevelStoneGUI", "play_music_sample")
		GuisManager.gui_call_method("LevelStoneGUI", "play_animation", ["open"])

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		GuisManager.gui_call_method("LevelStoneGUI", "stop_music_sample")
		GuisManager.gui_call_method("LevelStoneGUI", "play_animation", ["close"])
		GuisManager.hide_gui("LevelStoneGUI")
