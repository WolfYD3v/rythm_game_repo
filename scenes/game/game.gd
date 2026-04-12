extends Node
class_name Game

const INTRO_PACKED_SCENE: PackedScene = preload("res://scenes/intro/intro.tscn")

func _ready() -> void:
	SceneManager.add_scene("Intro", INTRO_PACKED_SCENE)
	SceneManager.replace_scene("Intro")
