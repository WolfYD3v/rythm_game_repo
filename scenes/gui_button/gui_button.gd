extends Button
class_name GuiButton

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var hover_sfx: AudioStream = null
@export var click_sfx: AudioStream = null

func _play_sfx(sfx: AudioStream) -> void:
	if disabled: return
	
	if audio_stream_player.playing: audio_stream_player.stop()
	if sfx:
		audio_stream_player.pitch_scale = randf_range(1.0, 2.5)
		audio_stream_player.stream = sfx
		audio_stream_player.play()

func _on_mouse_entered() -> void:
	_play_sfx(hover_sfx)

func _on_pressed() -> void:
	_play_sfx(click_sfx)
