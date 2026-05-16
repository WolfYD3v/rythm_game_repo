extends Control
class_name ContentWarning

@onready var content_warning_rich_text_label: RichTextLabel = $ContentWarningRichTextLabel
@onready var ambiance_audio_stream_player: AudioStreamPlayer = $AmbianceAudioStreamPlayer

const MAIN_MENU_PACKED_SCENE: PackedScene = preload("res://scenes/main_menu/main_menu.tscn")

var tween

func _ready() -> void:
	ambiance_audio_stream_player.play()
	content_warning_rich_text_label.visible_ratio = 0.0
	await get_tree().create_timer(1.5).timeout
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		content_warning_rich_text_label, "visible_ratio",
		1.0, 20.0
	)
	await tween.finished
	await get_tree().create_timer(3.5).timeout
	
	SceneManager.add_scene("MainMenu", MAIN_MENU_PACKED_SCENE)
	SceneManager.remove_scene("ContentWarning")
	SceneManager.replace_scene("MainMenu")
