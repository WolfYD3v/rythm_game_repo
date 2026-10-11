extends Node
class_name Game

const INTRO_SCENE_PATH: String = "res://scenes/intro/intro.tscn"

@export var dev_start_scene: PackedScene = null

func _ready() -> void:
	if not dev_start_scene:
		SceneManager.add_scene("Intro", INTRO_SCENE_PATH)
		SceneManager.replace_scene("Intro")
	else:
		SceneManager.add_scene(dev_start_scene.resource_name, dev_start_scene.resource_path)
		SceneManager.replace_scene(dev_start_scene.resource_name)
