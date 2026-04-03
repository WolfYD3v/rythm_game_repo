extends Node3D
class_name LevelStone

@onready var music_sample_audio_stream_player: AudioStreamPlayer = $MusicSampleAudioStreamPlayer
@onready var gameplay_icon_mesh: MeshInstance3D = $GameplayIconMesh
@onready var gui: CanvasLayer = $GUI
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var music_sample: AudioStream = null
@export var sample_start: float = 0.0
@export_range(5.0, 10.0, 0.1, "prefer_slider") var sample_duration: float = 5.0
enum GAMEPLAY_TYPES {
	LINES,
	REVERSED_LINES,
	BOSS_FIGHT
}
@export var gameplay_type: GAMEPLAY_TYPES = GAMEPLAY_TYPES.LINES
@export_range(1, 15, 1, "prefer_slider") var difficulty: int = 1

const LINE_LEVEL = preload("res://scenes/level/line_level/line_level.tscn")

var music_sample_can_repeat: bool = false

func _ready() -> void:
	gui.hide()
	set_gameplay_type_icon()
	setup_gui()
	
	music_sample_audio_stream_player.stream = music_sample
	if music_sample: 
		if sample_start >= music_sample.get_length(): sample_start = 0.0

func setup_gui() -> void:
	if music_sample:
		var music_sample_file_extension: String = ".%s" % music_sample.resource_path.get_extension()
		var music_sample_file_name: String = music_sample.resource_path.get_file().replace(
			music_sample_file_extension, ""
		)
		gui.get_node("Control/InfosContainer/SongNameRichTextLabel").text = "[u][b]%s[/b][/u]" % music_sample_file_name
	gui.get_node("Control/InfosContainer/ArtistsNameLabel").text = "artist(s) name(s) | TEMP"
	gui.get_node("Control/InfosContainer/DifficultyLabel").text = "%d  ★ " % difficulty

func set_gameplay_type_icon() -> void:
	var icon_path: String = ""
	match gameplay_type:
		GAMEPLAY_TYPES.LINES: icon_path = "res://WolfY_D3vPP.jpeg"
		GAMEPLAY_TYPES.REVERSED_LINES: icon_path = "res://icon.svg"
	
	if icon_path != "":
		print(icon_path)
		# Load the related icon of the gameplay
		var gameplay_icon_mesh_material: StandardMaterial3D = gameplay_icon_mesh.get_surface_override_material(0).duplicate()
		gameplay_icon_mesh_material.albedo_texture = load(icon_path)
		gameplay_icon_mesh.set_surface_override_material(0, gameplay_icon_mesh_material)

func play_music_sample() -> void:
	if not music_sample or not SettingsManager.listen_samples: return
	
	music_sample_can_repeat = true
	music_sample_audio_stream_player.play(sample_start)
	await get_tree().create_timer(sample_duration).timeout
	music_sample_audio_stream_player.stop()
	if music_sample_can_repeat: play_music_sample()

func stop_music_sample() -> void:
	music_sample_can_repeat = false
	music_sample_audio_stream_player.stop()

func play_animation(animation_name: String) -> void:
	if animation_player.is_playing(): animation_player.stop()
	
	if animation_name in animation_player.get_animation_list():
		animation_player.play(animation_name)

func change_scene_to_correct() -> void:
	var next_scene_name: String = ""
	var next_scene: PackedScene = null
	match gameplay_type:
		GAMEPLAY_TYPES.LINES:
			next_scene_name = "LinesLevel"
			next_scene = LINE_LEVEL
			LevelManager.level_data_to_be_used = {
				"env_scene": load("res://scenes/level/envs/test_env.tscn"),
				"song": music_sample
			}
		GAMEPLAY_TYPES.REVERSED_LINES:
			next_scene_name = "ReversedLinesLevel"
			next_scene = null # TEMP
		GAMEPLAY_TYPES.BOSS_FIGHT:
			next_scene_name = "BossFightLevel"
			next_scene = null # TEMP
	
	if next_scene:
		SceneManager.add_scene(next_scene_name, next_scene)
		SceneManager.replace_scene(next_scene_name)

func _on_player_detection_area_area_shape_entered(_area_rid: RID, _area: Area3D, _area_shape_index: int, _local_shape_index: int) -> void:
	play_music_sample()
	play_animation("open")
	gui.show()

func _on_player_detection_area_area_shape_exited(_area_rid: RID, _area: Area3D, _area_shape_index: int, _local_shape_index: int) -> void:
	stop_music_sample()
	play_animation("close")
	await animation_player.animation_finished
	gui.hide()

func _on_play_button_pressed() -> void:
	change_scene_to_correct()
