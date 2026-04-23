extends Node3D
class_name SongSelection

@onready var fading_black: ColorRect = $CanvasLayer/FadingBlack
@onready var ambiance_audio_stream_player: AudioStreamPlayer = $AmbianceAudioStreamPlayer

func _ready() -> void:
	LevelManager.song_selection_scene = self
	fading_black.hide()

func _on_go_back_gui_button_pressed() -> void:
	SceneManager.replace_scene("MainMenu")

func fading_back_in() -> void:
	var tween_duration: float = 5.0
	fading_black.modulate = Color(1.0, 1.0, 1.0, 0.0)
	fading_black.show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		fading_black, "modulate",
		Color(1.0, 1.0, 1.0, 1.0), tween_duration
	)
	tween.set_parallel(true)
	tween.tween_property(
		ambiance_audio_stream_player,
		"volume_db", -80, tween_duration * 3
	)
	await get_tree().create_timer(tween_duration).timeout
