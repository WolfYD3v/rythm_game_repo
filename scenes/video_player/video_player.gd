extends Control
class_name VideoPlayer

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var black_overlay: ColorRect = $BlackOverlay
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var auto_play: bool = true
@export var video_stream: VideoStream = null

enum BLACK_OVERLAY_FADING_MODES {
	IN,
	OUT
}

var black_overlay_fading_tween

func _ready() -> void:
	if auto_play: play(video_stream)

func play(_video_stream: VideoStream) -> void:
	if _video_stream:
		video_stream_player.stream = _video_stream
		video_stream_player.play()
		await get_tree().create_timer(0.01).timeout
		video_stream_player.paused = true
		await fade_black_fading(BLACK_OVERLAY_FADING_MODES.OUT)
		await get_tree().create_timer(0.5).timeout
		video_stream_player.paused = false
		await video_stream_player.finished
		await get_tree().create_timer(0.5).timeout
		await fade_black_fading(BLACK_OVERLAY_FADING_MODES.IN)
		await get_tree().create_timer(1.5).timeout
		GameManager.video_player_video_finished.emit()

func fade_black_fading(fade_mode: BLACK_OVERLAY_FADING_MODES) -> void:
	if black_overlay_fading_tween: black_overlay_fading_tween.kill()
	black_overlay_fading_tween = get_tree().create_tween()
	black_overlay_fading_tween.set_parallel(true)
	var size_y_to_apply: float = 0.0
	if fade_mode == BLACK_OVERLAY_FADING_MODES.IN: size_y_to_apply = 648.0
	else: size_y_to_apply = 0.0
	black_overlay_fading_tween.tween_property(
		black_overlay, "size:y",
		size_y_to_apply, 5.0
	)
	audio_stream_player.play()
	await black_overlay_fading_tween.finished
	audio_stream_player.stop()
