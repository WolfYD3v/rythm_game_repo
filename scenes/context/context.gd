extends Control
class_name Context

@onready var text_label: Label = $TextLabel

const SONG_SELECTION_PACKED_SCENE: PackedScene = preload("res://scenes/song_selection/song_selection.tscn")

var writing_duration: float = 15.0

func _ready() -> void:
	text_label.visible_ratio = 0.0
	if not SaveManager.get_save_data("context_seen"):
		await get_tree().create_timer(1.0).timeout
		await write_text()
		print("Writing Finished !")
		SaveManager.save_game(
			{"context_seen": true}
		)
	
	SceneManager.add_scene("SongSelection", SONG_SELECTION_PACKED_SCENE)
	SceneManager.replace_scene("SongSelection")

func write_text() -> void:
	var text_label_tween = get_tree().create_tween()
	text_label_tween.tween_property(
		text_label, "visible_ratio",
		1.0, writing_duration
	)
	await text_label_tween.finished
