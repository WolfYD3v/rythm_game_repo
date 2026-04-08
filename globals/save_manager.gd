extends Node

const BASE_SAVE_DATA: Dictionary = {
	"context_seen": false
}

var save_file_path: String = ProjectSettings.globalize_path("user://save.json")
var _loaded_save_data: Dictionary = {}

func _ready() -> void:
	delete_save()
	print(get_save_data("context_seen"))
	if not save_exist(): save_game()
	load_save()

func save_exist() -> bool:
	return FileAccess.file_exists(save_file_path)

func delete_save() -> void:
	if save_exist():
		DirAccess.remove_absolute(save_file_path)
		_loaded_save_data.clear()

func save_game() -> void:
	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if save_file:
		var save_data_to_write = BASE_SAVE_DATA.duplicate()
		# Add values to save
		
		var save_file_content: String = JSON.stringify(save_data_to_write, "    ")
		save_file.store_string(save_file_content)
		save_file.close()

func load_save() -> void:
	var save_file = FileAccess.open(save_file_path, FileAccess.READ)
	if save_file:
		var save_file_content: String = save_file.get_as_text()
		save_file.close()
		
		_loaded_save_data = JSON.parse_string(save_file_content)
		print(_loaded_save_data)
		print(get_save_data("context_seen"))
		print(get_save_data("e"))

func get_save_data(data: String) -> Variant:
	if _loaded_save_data.is_empty(): return null
	
	if _loaded_save_data.has(data): return _loaded_save_data.get(data)
	return null
