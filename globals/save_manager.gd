extends Node

signal game_saved
signal save_loaded

const SAVE_FILE_PATH: String = "user://save.tres"

var _globalized_save_file_path: String = ProjectSettings.globalize_path(SAVE_FILE_PATH)
var _loaded_save_file: Resource_SaveFile = null

func _ready() -> void:
	# Create an empty save file if it has not been found
	if not save_exist(): save_game(true)
	load_save()
	
	# If the save file is not up to date, update it
	# The new save file is filled with the values of the previous one
	#if not save_file_up_to_date():
		#delete_save()
		#save_game()
		#load_save()

#func save_file_up_to_date() -> bool:
	#var base_save_data_size: int = BASE_SAVE_DATA.size()
	#var loaded_save_data: int = _loaded_save_data.size()
	#var is_up_to_date: bool = true
	#
	## CODE
	#
	#return is_up_to_date

func save_exist() -> bool: return FileAccess.file_exists(_globalized_save_file_path)

func delete_save() -> void: if save_exist(): DirAccess.remove_absolute(_globalized_save_file_path)

func save_game(make_clean_file: bool = false) -> void:
	if not _loaded_save_file: make_clean_file = true
	
	var save_file_to_write: Resource_SaveFile = null
	if make_clean_file: save_file_to_write = Resource_SaveFile.new()
	else: save_file_to_write = _loaded_save_file.duplicate()
	
	ResourceSaver.save(save_file_to_write, _globalized_save_file_path)
	game_saved.emit()

func load_save() -> void:
	_loaded_save_file = ResourceLoader.load(_globalized_save_file_path)
	if _loaded_save_file: save_loaded.emit()

func get_save_data(data: String) -> Variant:
	if !_loaded_save_file: return null
	return _loaded_save_file.get(data)

func reset() -> void:
	save_game(true)
	load_save()
