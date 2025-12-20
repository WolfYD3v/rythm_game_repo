extends Node

const BASE_LEVEL_FILE_PATH = "res://base_level_file.json"

func load_level() -> Dictionary:
	var json_as_text: String = FileAccess.get_file_as_string(BASE_LEVEL_FILE_PATH)
	var json_as_dict: Dictionary = JSON.parse_string(json_as_text)
	if json_as_dict:
		print(json_as_dict)
	return json_as_dict
