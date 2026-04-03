extends Control
class_name Intro

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const MAIN_MENU_PACKED_SCENE: PackedScene = preload("res://scenes/main_menu/main_menu.tscn")
const CONTEXT_PACKED_SCENE: PackedScene = preload("res://scenes/context/context.tscn")

func _ready() -> void:
	animation_player.play("start")
	await animation_player.animation_finished
	
	# For the context scene
	#if true:
		#SceneManager.add_scene("Context", CONTEXT_PACKED_SCENE)
		#SceneManager.replace_scene("Context")
		#await get_tree().create_timer(1.0).timeout
		#SceneManager._current_scene.queue_free()
		#SceneManager.remove_scene("Context")
	
	SceneManager.add_scene("MainMenu", MAIN_MENU_PACKED_SCENE)
	SceneManager.remove_scene("Intro")
	SceneManager.replace_scene("MainMenu")
