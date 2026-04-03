extends Node

signal targeted_intensity_signaled

var json_level_file_path: String = ""
var input_countdown_timer_duration: float = 0.0
var input_countdown_timer: Timer = null

var targeted_intensity: float = 0.0
var current_intensity: float = 0.0:
	set(value):
		current_intensity = value
		if current_intensity >= targeted_intensity and input_countdown_timer.is_stopped():
			targeted_intensity_signaled.emit()
			input_countdown_timer.start(input_countdown_timer_duration)

var level_data_to_be_used: Dictionary = {}

func _ready() -> void:
	var timer: Timer = Timer.new()
	timer.name = "InputCountdownTimer"
	timer.one_shot = true
	get_tree().root.add_child.call_deferred(timer)
	input_countdown_timer = timer

func load_level(new_json_level_file_path: String = "") -> Dictionary:
	if new_json_level_file_path != "":
		json_level_file_path = new_json_level_file_path
	var json_as_text: String = FileAccess.get_file_as_string(json_level_file_path)
	var json_as_dict: Dictionary = JSON.parse_string(json_as_text)
	if not json_as_dict:
		return {}
	input_countdown_timer_duration = json_as_dict.get("input_countdown_timer_duration")
	return json_as_dict
