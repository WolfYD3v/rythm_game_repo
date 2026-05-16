extends Control

@export var song_file: AudioStream = null
@export var very_fast: bool = true

@onready var song_audio_stream_player: AudioStreamPlayer = $SongAudioStreamPlayer
@onready var sound_wave: SoundWave = $SoundWave

var base_song_data_file_content: Array[LineLevelBbstaclesSet] = []
var intesnsities: Array[Array] = []

func _ready() -> void:
	if not song_file:
		push_warning("No song file imputed")
		await get_tree().create_timer(0.1).timeout
		get_tree().quit()
	
	song_audio_stream_player.stream = song_file

func _on_create_file_button_pressed() -> void:
	if very_fast:
		Engine.time_scale = 20.0
	song_audio_stream_player.play()
	sound_wave.up_timer()
	await song_audio_stream_player.finished
	
	var file = FileAccess.open("res://eer.json", FileAccess.WRITE)
	if file:
		file.store_string(
			JSON.stringify(intesnsities, "    ")
		)

func _on_close_button_pressed() -> void:
	get_tree().quit()


func _on_sound_wave_intensity_calculated(data: Array) -> void:
	if data[1] >= 0.55 and $Timer.is_stopped():
		$Timer.start(0.5)
		print(data)
		intesnsities.append(data)
