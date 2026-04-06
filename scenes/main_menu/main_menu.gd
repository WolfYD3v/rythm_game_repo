extends Control
class_name MainMenu

@onready var hoyploma_sub_viewport: SubViewport = $HoyplomaSubViewport

const SETTINGS_PACKED_SCENE: PackedScene = preload("res://scenes/settings/settings.tscn")
const SONG_SELECTION_PACKED_SCENE: PackedScene = preload("res://scenes/song_selection/song_selection.tscn")

func _ready() -> void:
	hoyploma_sub_viewport.add_child(
		SceneManager.get_scene("Hoyploma").instantiate()
	)
	SceneManager.add_scene("Settings", SETTINGS_PACKED_SCENE)
	SceneManager.add_scene("SongSelection", SONG_SELECTION_PACKED_SCENE)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	SceneManager.replace_scene("Settings")

func _on_play_button_pressed() -> void:
	SceneManager.replace_scene("SongSelection")
