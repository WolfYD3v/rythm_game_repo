extends Node

signal game_saved
signal save_loaded

const BASE_SAVE_DATA: Dictionary = {
	"context_seen": false
}

var save_file_path: String = ProjectSettings.globalize_path("user://save.json")
var _loaded_save_data: Dictionary = {}

func _ready() -> void:
	# Create an empty save file if it has not been found
	if not save_exist(): save_game()
	load_save()
	
	# If the save file is not up to date, update it
	# The new save file is filled with the values of the previous one
	if not save_file_up_to_date():
		delete_save()
		save_game(_loaded_save_data)
		load_save()
	
	print(_loaded_save_data)

func save_file_up_to_date() -> bool:
	var base_save_data_size: int = BASE_SAVE_DATA.size()
	var loaded_save_data: int = _loaded_save_data.size()
	
	return base_save_data_size == loaded_save_data

func save_exist() -> bool:
	return FileAccess.file_exists(save_file_path)

func delete_save() -> void:
	if save_exist(): DirAccess.remove_absolute(save_file_path)

func save_game(values_to_save: Dictionary = {}) -> void:
	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if save_file:
		var save_data_to_write = BASE_SAVE_DATA.duplicate()
		# Setup the values to change
		if not values_to_save.is_empty():
			for data: String in values_to_save.keys():
				if save_data_to_write.has(data): save_data_to_write.set(data, values_to_save[data])
		
		var save_file_content: String = JSON.stringify(save_data_to_write, "    ")
		save_file.store_string(save_file_content)
		save_file.close()
		
		game_saved.emit()

func load_save() -> void:
	var save_file = FileAccess.open(save_file_path, FileAccess.READ)
	if save_file:
		var save_file_content: String = save_file.get_as_text()
		save_file.close()
		
		_loaded_save_data = JSON.parse_string(save_file_content)
		save_loaded.emit()

func get_save_data(data: String) -> Variant:
	if _loaded_save_data.is_empty(): return null
	return _loaded_save_data.get(data)
