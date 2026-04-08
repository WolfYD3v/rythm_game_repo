extends Control
class_name PauseMenu

@onready var settings: Control = $Settings

func _ready() -> void:
	settings.hide()
	set_pause(false)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_ESCAPE):
			set_pause(
				not(get_tree().paused)
			)

func set_pause(value: bool) -> void:
	get_tree().paused = value
	visible = value
	if not value: settings.hide()

func _on_continue_button_pressed() -> void:
	set_pause(false)

func _on_settings_button_pressed() -> void:
	settings.show()
