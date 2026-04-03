extends Control

@export var song_name: String = ""
@export var song_file: AudioStream = null
@export_range(0.0, 1.0) var targeted_intensity: float = 0.5
@export_range(0.1, 1.0) var input_countdown_timer_duration: float = 0.5

@onready var song_audio_stream_player: AudioStreamPlayer = $SongAudioStreamPlayer
@onready var output_label: Label = $OutputLabel

var base_song_data_file_content: Dictionary = {
	"song": "",
	"targeted_intensity": 0.5,
	"input_countdown_timer_duration": 0.5,
	"inputs": {}
}

func create_song_data_file() -> void:
	var file_path: String = "res://" + song_name + ".json"
	if FileAccess.file_exists(file_path): DirAccess.remove_absolute(file_path)
	
	var song_data_file = FileAccess.open(file_path, FileAccess.WRITE)
	var data_to_write = base_song_data_file_content.duplicate()
	
	data_to_write["song"] = song_file.resource_path
	data_to_write["targeted_intensity"] = targeted_intensity
	data_to_write["input_countdown_timer_duration"] = input_countdown_timer_duration
	data_to_write["inputs"] = await get_inputs()
	
	song_data_file.store_string(
		JSON.stringify(data_to_write, "    ", false)
	)
	
	await get_tree().create_timer(5.0).timeout
	get_tree().quit()

func play_song() -> void:
	song_audio_stream_player.stream = song_file
	song_audio_stream_player.play()
	print(song_audio_stream_player.stream)

func get_inputs() -> Dictionary:
	var inputs: Dictionary = {}
	play_song()
	
	var song_lenght: float = song_audio_stream_player.stream.get_length()
	var cur_song_time: float = 0.0
	while cur_song_time < song_lenght:
		cur_song_time = snappedf(cur_song_time + input_countdown_timer_duration, 0.01)
		if LevelManager.current_intensity >= input_countdown_timer_duration:
			inputs[cur_song_time] = snappedf(LevelManager.current_intensity, 0.01)
			output_label.text = str(cur_song_time) + " | " + str(LevelManager.current_intensity)
		await get_tree().create_timer(input_countdown_timer_duration).timeout
	
	return inputs

func _on_create_file_button_pressed() -> void:
	Engine.time_scale = 20.0
	create_song_data_file()

func _on_close_button_pressed() -> void:
	get_tree().quit()
