extends Camera3D

var image_save_path: String = "user://img.png"

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	_take_screenshot_game()

func _take_screenshot_game() -> void:
	var image: Image = get_viewport().get_texture().get_image()
	image.save_png(image_save_path)
