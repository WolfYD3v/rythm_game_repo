extends Node

const SONG_SELECTION_PACKED_SCENE: PackedScene = preload("res://scenes/song_selection/song_selection.tscn")
const ENVS_FOLDER_PATH: String = "res://scenes/level/line_level/envs/"
const ENNEMIES_FOLDER_PATH: String = "res://scenes/level/line_level/ennemies/"

const LINE_LEVEL_PACKED_SCENE: PackedScene = preload("res://scenes/level/line_level/line_level.tscn")

var song_selection_scene: SongSelection = null
var level_scene_name: String = "Level"

var max_level_id: int = 1
var max_levels_count: int = 2

func _ready() -> void:
	pass

func go_to_level(level_packed_scene: PackedScene) -> void:
	await song_selection_scene.fading_back_in()
	
	SceneManager.remove_scene(level_scene_name)
	SceneManager.add_scene(level_scene_name, level_packed_scene)
	SceneManager.replace_scene(level_scene_name)

func _get_valid_files_at(location: String) -> Array[String]:
	var valid_files_array: Array[String] = []
	var invalid_files_extension: Array[String] = ["gd", "uid", "export"]
	
	var location_dir = DirAccess.open(location)
	if location_dir:
		location_dir.include_hidden = true
		location_dir.list_dir_begin()
		var current_file: String = location_dir.get_next()
		while current_file != "":
			if not location_dir.current_is_dir():
				if not current_file.get_extension() in invalid_files_extension:
					valid_files_array.append(current_file)
			current_file = location_dir.get_next()
		location_dir.list_dir_end()
	else:
		push_warning("ERROR: Cannot open directory '%s'" % location)
	
	return valid_files_array

func win() -> void:
	if max_levels_count <= max_level_id + 1:
		max_level_id += 1
		SaveManager.save_game({"max_level_id": max_level_id})
	go_back_to_song_selection()

func go_back_to_song_selection() -> void:
	if not SceneManager.has_scene("SongSelection"): SceneManager.add_scene(
		"SongSelection",
		SONG_SELECTION_PACKED_SCENE
	)
	SceneManager.replace_scene("SongSelection")
