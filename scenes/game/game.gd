extends Node
class_name Game

const INTRO_PACKED_SCENE: PackedScene = preload("res://scenes/intro/intro.tscn")
const HOYPLOMA_PACKED_SCENE: PackedScene = preload("res://scenes/hoyploma/hoyploma.tscn")

func _ready() -> void:
	SettingsManager.get_settings()
	TranslationServer.set_locale(SettingsManager.language)
	
	SceneManager.add_scene("Hoyploma", HOYPLOMA_PACKED_SCENE)
	SceneManager.add_scene("Intro", INTRO_PACKED_SCENE)
	SceneManager.replace_scene("Intro")
