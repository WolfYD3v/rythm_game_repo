extends Node3D
class_name SongSelection

@onready var fading_black: ColorRect = $CanvasLayer/FadingBlack
@onready var ambiance_audio_stream_player: AudioStreamPlayer = $AmbianceAudioStreamPlayer
@onready var loading_animation: LoadingAnimation = $CanvasLayer/FadingBlack/LoadingAnimation
@onready var level_stones: Node3D = $LevelStones
@onready var player: Player = $Player

@export var to_last_level: bool = false

func _ready() -> void:
	if to_last_level: LevelManager.max_level_id = LevelManager.max_levels_count
	
	LevelManager.song_selection_scene = self
	fading_black.hide()
	set_player_pos()

func _on_go_back_gui_button_pressed() -> void:
	SceneManager.replace_scene("MainMenu")

func fading_back_in() -> void:
	loading_animation.play()
	
	var tween_duration: float = 5.0
	fading_black.modulate = Color(1.0, 1.0, 1.0, 0.0)
	fading_black.show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		fading_black, "modulate",
		Color(1.0, 1.0, 1.0, 1.0), tween_duration
	)
	tween.set_parallel(true)
	tween.tween_property(
		ambiance_audio_stream_player,
		"volume_db", -80, tween_duration * 3
	)
	await get_tree().create_timer(tween_duration).timeout

func set_player_pos() -> void:
	# Setup some variables
	var new_player_position: Vector3 = Vector3.ZERO
	var level_stone_idx: int = 0
	
	# Get the new player position
	if LevelManager.max_level_id > 1: level_stone_idx = LevelManager.max_level_id - 1
	else: level_stone_idx = 0
	new_player_position = level_stones.get_child(level_stone_idx).get_pos_marker_position()
	
	# Change the player position
	if level_stone_idx <= 0: player.position = new_player_position # No stones behind -> No walking animation
	else:
		# Stone behind the next one, start the walking animation
		player.position = level_stones.get_child(level_stone_idx - 1).get_pos_marker_position()
		await get_tree().create_timer(1.5).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(
			player, "position",
			new_player_position, 5.0
		)
		await tween.finished
		tween.kill()
