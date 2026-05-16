extends Camera3D

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	_take_screenshot_game()

func _take_screenshot_game() -> void:
	var img := get_viewport().get_texture().get_image()
	img.save_png("user://img.png")
