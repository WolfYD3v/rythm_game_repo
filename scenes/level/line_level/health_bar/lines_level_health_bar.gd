extends Control
class_name LinesLevelHealthBar

signal empty

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var tween
var tween_duration: float = 1.5

func _ready() -> void:
	hide()

func init_health_bar(hb_max_value: int) -> void:
	if hb_max_value <= 0: hb_max_value = 1
	progress_bar.max_value = hb_max_value
	progress_bar.value = hb_max_value
	
	print("Health Bar: %d" % hb_max_value)

func lower(amount: float) -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(
		progress_bar, "value",
		progress_bar.value - amount, 0.2
	)
	tween.finished.connect(
		func():
			if progress_bar.value <= 0.0: empty.emit()
	)

func popup() -> void:
	progress_bar.size.x = 0.0
	progress_bar.modulate = Color(0.0, 0.0, 0.0, 0.0)
	
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_parallel(true)
	tween.tween_property(
		progress_bar, "size:x",
		100.0, tween_duration
	)
	tween.tween_property(
		progress_bar, "modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		tween_duration * 1.5
	)
	
	audio_stream_player.play()
	show()
