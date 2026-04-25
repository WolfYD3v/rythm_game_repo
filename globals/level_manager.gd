extends Node

const ENVS_FOLDER_PATH: String = "res://scenes/level/line_level/envs/"
const ENNEMIES_FOLDER_PATH: String = "res://scenes/level/line_level/ennemies/"

const LINE_LEVEL_PACKED_SCENE: PackedScene = preload("res://scenes/level/line_level/line_level.tscn")

var song_selection_scene: SongSelection = null

var max_level_id: int = 1

var song: AudioStream = null
var env_scene: PackedScene = null
var ennemy_scene: PackedScene = null
var obstacle_sets_array: Array[LineLevelBbstaclesSet] = []

var envs_collection: Array[String] = []
var ennemies_collection: Array[String] = []

func _ready() -> void:
	envs_collection = _get_valid_files_at(ENVS_FOLDER_PATH)
	ennemies_collection = _get_valid_files_at(ENNEMIES_FOLDER_PATH)

func set_level_data(level_stone: LevelStone) -> void:
	var idx: int = max_level_id - 1
	
	song = level_stone.music_sample
	if envs_collection.size() >= idx + 1 and not envs_collection.is_empty():
		env_scene = load(ENVS_FOLDER_PATH + envs_collection[idx])
	if ennemies_collection.size() >= idx + 1 and not ennemies_collection.is_empty():
		ennemy_scene = load(ENNEMIES_FOLDER_PATH + ennemies_collection[idx])
	obstacle_sets_array = [] # TEMP

func go_to_level(level_stone: LevelStone) -> void:
	await song_selection_scene.fading_back_in()
	
	var next_scene_name: String = ""
	var next_packed_scene: PackedScene = null
	
	match level_stone.gameplay_type:
		LevelStone.GAMEPLAY_TYPES.LINES:
			next_scene_name = "LinesLevel"
			next_packed_scene = LINE_LEVEL_PACKED_SCENE
		LevelStone.GAMEPLAY_TYPES.BOSS_FIGHT:
			next_scene_name = "BossFightLevel"
			next_packed_scene = null # TEMP
	
	if next_packed_scene:
		SceneManager.remove_scene(next_scene_name)
		SceneManager.add_scene(next_scene_name, next_packed_scene)
		SceneManager.replace_scene(next_scene_name)

func _get_valid_files_at(location: String) -> Array[String]:
	var valid_files_array: Array[String] = []
	var invalid_files_extension: Array[String] = ["gd", "uid"]
	
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

func game_over() -> void:
	print("Ouch...")
	#if not SceneManager.has_scene("SongSelection"):
		#SceneManager.add_scene(
			#"SongSelection",
			#load("res://scenes/song_selection/song_selection.tscn")
		#)
	#SceneManager.replace_scene("SongSelection")
