extends Node3D
class_name SongSelection

@onready var map: TextureRect = $CanvasLayer/Control/Map
@onready var fading_black: ColorRect = $CanvasLayer/FadingBlack

func _ready() -> void:
	LevelManager.song_selection_scene = self
	fading_black.hide()
	map.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_M): map.visible = not(map.visible)

func _on_go_back_button_pressed() -> void:
	SceneManager.replace_scene("MainMenu")

func fading_back_in() -> void:
	fading_black.modulate = Color(1.0, 1.0, 1.0, 0.0)
	fading_black.show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		fading_black, "modulate",
		Color(1.0, 1.0, 1.0, 1.0), 5.0
	)
	await tween.finished
