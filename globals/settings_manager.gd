extends Node

const BASE_SETTINGS_FILE_CONTENT: Dictionary = {
	"listen_samples": true,
	"language": "en",
	"keybinds": {
		"Tile1": KEY_A,
		"Tile2": KEY_Z,
		"Tile3": KEY_E,
		"Tile4": KEY_R,
		"Tile5": KEY_T,
		"Tile6": KEY_Y,
	}
}
var settings_file_path: String = ProjectSettings.globalize_path("user://settings_file.json")

var listen_samples: bool = true
var language: String = "en"
var keybinds: Dictionary = {}



func _ready() -> void:
	delete_settings_file(true)
	if not settings_file_exists(): save_settings_file()
	
	get_settings()
	_load_settings_data()



func settings_file_exists() -> bool:
	return FileAccess.file_exists(settings_file_path)

func delete_settings_file(forced: bool = false) -> void:
	if settings_file_exists() or forced: DirAccess.remove_absolute(settings_file_path)

func save_settings_file() -> void:
	var settings_file = FileAccess.open(settings_file_path, FileAccess.WRITE)
	if settings_file:
		var settings_file_content: Dictionary = BASE_SETTINGS_FILE_CONTENT.duplicate()
		settings_file_content["listen_samples"] = listen_samples
		settings_file_content["language"] = language
		
		settings_file.store_string(
			JSON.stringify(settings_file_content, "    ", false, false)
		)
		settings_file.close()

func get_settings() -> void:
	if not settings_file_exists(): return
	
	var settings_file = FileAccess.open(settings_file_path, FileAccess.READ)
	if settings_file:
		var settings_dictionnary: Dictionary = JSON.parse_string(
			settings_file.get_as_text()
		)
		for variable: String in settings_dictionnary.keys():
			var value: Variant = settings_dictionnary[variable]
			set(variable, value)
			print("%s = %s" % [variable, value])

func _load_settings_data() -> void:
	TranslationServer.set_locale(language)
	_load_saved_keybinds()

func _load_saved_keybinds() -> void:
	if keybinds.is_empty(): return
	
	for action: String in keybinds.keys():
		if not InputMap.has_action(action): continue
		
		var _keybind: InputEventKey = InputEventKey.new()
		_keybind.keycode = keybinds.get(action)
		InputMap.action_erase_event(
			action,
			InputMap.action_get_events(action)[-1]
		)
		InputMap.action_add_event(action, _keybind)
		print("Action '%s' -> %s" % [action, _keybind])
