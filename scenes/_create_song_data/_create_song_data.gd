extends Control

@export var song_file: AudioStream = null

@onready var song_audio_stream_player: AudioStreamPlayer = $SongAudioStreamPlayer
@onready var output_label: Label = $OutputLabel

var base_song_data_file_content: Dictionary[float, LineLevelObstacle] = {}

func create_song_data_file() -> void:
	if song_file:
		var song_name: String = song_file.resource_path.get_file()
		var file_path: String = "res://%s_song_data.json" % song_name
		if FileAccess.file_exists(file_path): DirAccess.remove_absolute(file_path)
		
		var song_data_file = FileAccess.open(file_path, FileAccess.WRITE)
		var data_to_write = base_song_data_file_content.duplicate()
		
		data_to_write["song"] = song_file.resource_path
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
	var timer: float = 0.0
	while timer < song_lenght:
		inputs[timer] = snappedf(LevelManager.current_intensity, 0.01)
		timer = snappedf(timer + 0.01, 0.01)
		#output_label.text = str(cur_song_time) + " | " + str(LevelManager.current_intensity)
	
	return inputs

func _on_create_file_button_pressed() -> void:
	Engine.time_scale = 20.0
	create_song_data_file()

func _on_close_button_pressed() -> void:
	get_tree().quit()
