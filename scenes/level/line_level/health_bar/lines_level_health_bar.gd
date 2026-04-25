extends Control
class_name LinesLevelHealthBar

signal empty

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func init_health_bar(hb_max_value: int) -> void:
	if hb_max_value <= 0: hb_max_value = 1
	progress_bar.max_value = hb_max_value
	progress_bar.value = hb_max_value
	
	print("Health Bar: %d" % hb_max_value)

func lower(amount: int) -> void:
	print("-%d" % amount)
	progress_bar.value -= amount
	if progress_bar.value <= 0: empty.emit()
