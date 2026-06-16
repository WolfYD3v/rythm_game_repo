extends Node
class_name Game

@onready var current_scene: Node = $CurrentScene
@onready var guis: CanvasLayer = $GUIS

const INTRO_SCENE_PATH: String = "res://scenes/intro/intro.tscn"

func _ready() -> void:
	SceneManager.scene_changed.connect(change_current_scene)
	GuisManager.scan_for_guis_from(guis.get_child(0))
	GuisManager.hide_all_guis()
	
	SceneManager.add_scene("Intro", INTRO_SCENE_PATH)
	SceneManager.replace_scene("Intro")

func change_current_scene(new_scene: Node) -> void:
	if current_scene.get_child_count() > 0:
		for child_scene: Node in current_scene.get_children():
			child_scene.queue_free()
	current_scene.add_child(new_scene)
