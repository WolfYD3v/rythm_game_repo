extends Control
class_name Intro

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer

const CONTENT_WARNING_SCENE_PATH: String = "res://scenes/content_warning/content_warning.tscn"

func _ready() -> void:
	video_stream_player.play()
	await video_stream_player.finished
	
	SceneManager.add_scene("ContentWarning", CONTENT_WARNING_SCENE_PATH)
	SceneManager.remove_scene("Intro")
	SceneManager.replace_scene("ContentWarning")
