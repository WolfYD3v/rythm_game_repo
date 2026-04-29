extends Control

signal scan_finished

@export var song_file: AudioStream = null
@export var very_fast: bool = true

@onready var song_audio_stream_player: AudioStreamPlayer = $SongAudioStreamPlayer

var base_song_data_file_content: Array[LineLevelBbstaclesSet] = []

func _ready() -> void:
	if song_file: song_audio_stream_player.stream = song_file
	else:
		push_warning("No song file imputed")
		await get_tree().create_timer(0.1).timeout
		get_tree().quit()

func create_song_data_resource() -> void:
	if song_file:
		var song_name: String = song_file.resource_path.get_file()
		var resource_path: String = "res://%s_song_data.json" % "e"
		if FileAccess.file_exists(resource_path): DirAccess.remove_absolute(resource_path)
		
		song_audio_stream_player.play()
		get_inputs()
		await scan_finished
		
		var resource: LineLevelAllObstacleSets = LineLevelAllObstacleSets.new()
		resource.obstacle_sets = base_song_data_file_content
		var error = ResourceSaver.save(resource, resource_path)
		if error != OK: print("echec")
		
		await get_tree().create_timer(5.0).timeout
		get_tree().quit()

func get_inputs() -> void:
	var song_lenght: float = song_audio_stream_player.stream.get_length()
	
	for timer: float in range(song_lenght):
		var obstacles_set: LineLevelBbstaclesSet = LineLevelBbstaclesSet.new()
		obstacles_set.at_time = timer
		var obstacle: LineLevelObstacle = LineLevelObstacle.new()
		obstacles_set.obstacles.append(obstacle)
		base_song_data_file_content.append(obstacles_set)
		print(timer)
		timer += 1.0
		#await get_tree().create_timer(0.1).timeout
	scan_finished.emit()

func _on_create_file_button_pressed() -> void:
	if very_fast:
		Engine.time_scale = 20.0
		song_audio_stream_player.pitch_scale = 20.0
	create_song_data_resource()

func _on_close_button_pressed() -> void:
	get_tree().quit()
