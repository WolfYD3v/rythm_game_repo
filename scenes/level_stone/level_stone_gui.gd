extends Control
class_name LevelStoneGUI

signal play_button_pressed

@onready var music_sample_audio_stream_player: AudioStreamPlayer = $MusicSampleAudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_button: Button = $PlayButton

@export var song_data: SongData = null

var music_sample_can_repeat: bool = false
var sample_start: float = 0.0
var sample_duration: float = 5.0

func _ready() -> void:
	#GameManager.look_at_map_changed.connect(
		#func():
			#if GameManager.look_at_map: play_animation("close")
			#else: play_animation("open")
	#)
	pass

func setup(_song_data: SongData, _sample_start: float, _difficulty: int, _play_button_locked: bool) -> void:
	song_data = _song_data
	sample_start = _sample_start
	
	_setup_music_sample_player()
	_setup_gui(_difficulty, _play_button_locked)

func _setup_music_sample_player() -> void:
	music_sample_audio_stream_player.stream = song_data.song
	if song_data.song: 
		if sample_start >= song_data.song.get_length(): sample_start = 0.0

func _setup_gui(difficulty: int, play_button_locked: bool) -> void:
	play_button.disabled = play_button_locked
	if song_data.song:
		var music_sample_file_extension: String = ".%s" % song_data.song.resource_path.get_extension()
		var music_sample_file_name: String = song_data.song.resource_path.get_file().replace(
			music_sample_file_extension, ""
		)
		get_node("NODES/InfosContainer/SongNameRichTextLabel").text = "[u][b]%s[/b][/u]" % music_sample_file_name
		get_node("NODES/InfosContainer/ArtistsNameLabel").text = song_data.artist_name
		get_node("NODES/InfosContainer/DifficultyLabel").text = "%d  ★ " % difficulty

func play_music_sample() -> void:
	if not song_data.song or not SettingsManager.listen_samples: return
	
	music_sample_can_repeat = true
	music_sample_audio_stream_player.play(sample_start)
	await get_tree().create_timer(sample_duration).timeout
	music_sample_audio_stream_player.stop()
	if music_sample_can_repeat: play_music_sample()

func stop_music_sample() -> void:
	music_sample_can_repeat = false
	music_sample_audio_stream_player.stop()

func play_animation(animation_name: String) -> void:
	if animation_player.is_playing(): animation_player.stop()
	
	if animation_name in animation_player.get_animation_list():
		animation_player.play(animation_name)

func _on_play_button_pressed() -> void:
	play_button_pressed.emit()
