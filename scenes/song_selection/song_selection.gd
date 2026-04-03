extends Node3D
class_name SongSelection

@onready var map: TextureRect = $CanvasLayer/Control/Map

func _ready() -> void:
	map.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_M): map.visible = not(map.visible)

func _on_go_back_button_pressed() -> void:
	SceneManager.replace_scene("MainMenu")
