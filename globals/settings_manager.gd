extends Node

const BASE_SETTINGS_FILE_CONTENT: Dictionary = {
	"listen_samples": true,
	"language": "en"
}
var settings_file_path: String = ProjectSettings.globalize_path("user://settings_file.json")

var listen_samples: bool = true
var language: String = "en"



func _ready() -> void:
	delete_settings_file(true)
	if not settings_file_exists(): save_settings_file()



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
