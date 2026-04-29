extends Control
class_name LooseScreen

func _ready() -> void:
	hide()

func _on_quit_button_pressed() -> void:
	LevelManager.go_back_to_song_selection()

func _on_retry_button_pressed() -> void:
	SceneManager.reload_current_scene()
