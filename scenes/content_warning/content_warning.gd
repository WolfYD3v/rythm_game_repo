extends Control
class_name ContentWarning

@onready var content_warning_rich_text_label: RichTextLabel = $ContentWarningRichTextLabel
@onready var ambiance_audio_stream_player: AudioStreamPlayer = $AmbianceAudioStreamPlayer
@onready var text_audio_stream_player: AudioStreamPlayer = $TextAudioStreamPlayer

const MAIN_MENU_SCENE_PATH: String = "res://scenes/main_menu/main_menu.tscn"

var tween

func _ready() -> void:
	ambiance_audio_stream_player.play()
	content_warning_rich_text_label.visible_ratio = 0.0
	await get_tree().create_timer(1.5).timeout
	
	var loop_wait_time: float = 0.4
	while content_warning_rich_text_label.visible_ratio < 1.0:
		content_warning_rich_text_label.visible_ratio += 0.01
		text_audio_stream_player.play()
		await get_tree().create_timer(loop_wait_time).timeout
		loop_wait_time = clampf(loop_wait_time - 0.015, 0.05, 999.0)
	
	await get_tree().create_timer(10.0).timeout
	leave_content_warning_scene()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): leave_content_warning_scene()

func play_text_sfx() -> void:
	text_audio_stream_player.pitch_scale = randf_range(1.0, 1.5)
	text_audio_stream_player.play()

func leave_content_warning_scene() -> void:
	SceneManager.add_scene("MainMenu", MAIN_MENU_SCENE_PATH)
	SceneManager.remove_scene("ContentWarning")
	SceneManager.replace_scene("MainMenu")
