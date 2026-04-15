extends Node

const ENVS_FOLDER_PATH: String = "res://scenes/level/line_level/envs/"
const ENNEMIES_FOLDER_PATH: String = "res://scenes/level/line_level/ennemies/"

const LINE_LEVEL_PACKED_SCENE: PackedScene = preload("res://scenes/level/line_level/line_level.tscn")

var max_level_id: int = 1

var song: AudioStream = null
var env_scene: PackedScene = null
var ennemy_scene: PackedScene = null
var obstacles_dict: Dictionary = {}

var envs_collection: PackedStringArray = []
var ennemies_collection: PackedStringArray = []

func _ready() -> void:
	envs_collection = _get_files_at(ENVS_FOLDER_PATH)
	for eli in envs_collection:
		if eli.ends_with(".gd") or eli.ends_with(".uid"): envs_collection.erase(eli)
	ennemies_collection = _get_files_at(ENNEMIES_FOLDER_PATH)
	for el in ennemies_collection:
		if el.ends_with(".gd") or el.ends_with(".uid"): ennemies_collection.erase(el)

func set_level_data(level_stone: LevelStone) -> void:
	var idx: int = max_level_id - 1
	
	song = level_stone.music_sample
	if envs_collection.size() >= idx + 1 and not envs_collection.is_empty():
		env_scene = load(ENVS_FOLDER_PATH + envs_collection[idx])
	if ennemies_collection.size() >= idx + 1 and not ennemies_collection.is_empty():
		ennemy_scene = load(ENNEMIES_FOLDER_PATH + ennemies_collection[idx])
	obstacles_dict = {} # TEMP

func go_to_level(level_stone: LevelStone) -> void:
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

func _get_files_at(location: String) -> PackedStringArray:
	return DirAccess.get_files_at(location)
