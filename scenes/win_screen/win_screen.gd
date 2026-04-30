extends Control
class_name WinScreen

signal continuing

func _ready() -> void:
	hide()

func _on_continue_button_pressed() -> void:
	continuing.emit()
