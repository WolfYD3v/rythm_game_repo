extends Control
class_name Intro

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ambiance_audio_stream_player: AudioStreamPlayer = $AmbianceAudioStreamPlayer

const MAIN_MENU_PACKED_SCENE: PackedScene = preload("res://scenes/main_menu/main_menu.tscn")

func _ready() -> void:
	animation_player.play("start")
	ambiance_audio_stream_player.play()
	await animation_player.animation_finished
	await get_tree().create_timer(5.0).timeout
	
	SceneManager.add_scene("MainMenu", MAIN_MENU_PACKED_SCENE)
	SceneManager.remove_scene("Intro")
	SceneManager.replace_scene("MainMenu")
