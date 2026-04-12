extends Control
class_name Context

@onready var animation_player: AnimationPlayer = $SubViewport/AnimationPlayer
@onready var text_label: Label = $TextLabel
@onready var _3dbg_texture_rect: TextureRect = $_3DBGTextureRect

@export var force_play: bool = false

const SONG_SELECTION_PACKED_SCENE: PackedScene = preload("res://scenes/song_selection/song_selection.tscn")

var writing_duration: float = 0.0

func _ready() -> void:
	var move_char_animation: Animation = animation_player.get_animation("move_char")
	writing_duration = move_char_animation.length
	
	_3dbg_texture_rect.modulate = Color(1.0, 1.0, 1.0, 0.0)
	text_label.visible_ratio = 0.0
	if not SaveManager.get_save_data("context_seen") or force_play:
		await get_tree().create_timer(1.0).timeout
		animate_3d_bg_texture_rect()
		
		await write_text()
		print("Writing Finished !")
		SaveManager.save_game(
			{"context_seen": true}
		)
		
		await get_tree().create_timer(5.0).timeout
	
	SceneManager.add_scene("SongSelection", SONG_SELECTION_PACKED_SCENE)
	SceneManager.replace_scene("SongSelection")

func write_text() -> void:
	var text_label_tween = get_tree().create_tween()
	text_label_tween.tween_property(
		text_label, "visible_ratio",
		1.0, writing_duration
	)
	await text_label_tween.finished

func animate_3d_bg_texture_rect():
	animation_player.play("move_char")
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		_3dbg_texture_rect, "modulate",
		Color(1.0, 1.0, 1.0, 1.0), writing_duration
	)
