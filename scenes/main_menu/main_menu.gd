extends Node3D
class_name MainMenu

@onready var blue_bg: ColorRect = $CanvasLayer/BlueBG
@onready var gui: Control = $CanvasLayer/GUI
@onready var credits_rich_text_label: RichTextLabel = $CanvasLayer/CreditsRichTextLabel

const SETTINGS_SCENE_PATH: String = "res://scenes/settings/settings.tscn"
const HOYPLOMA_SCENE_PATH: String = "res://scenes/hoyploma/hoyploma.tscn"

func _ready() -> void:
	gui.show()
	set_credits_visibility(false)

func set_credits_visibility(value: bool) -> void:
	credits_rich_text_label.visible = value
	gui.visible = not(value)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	SceneManager.add_scene("Settings", SETTINGS_SCENE_PATH)
	SceneManager.replace_scene("Settings")

func _on_new_game_button_pressed() -> void:
	gui.hide()
	await get_tree().create_timer(1.0).timeout
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(blue_bg, "modulate", Color(0.0, 0.0, 0.0, 0.0), 5.0)
	#await tween.finished
	
	SaveManager.reset()
	await get_tree().create_timer(0.5).timeout
	SceneManager.add_scene("Map", ChaptersManager.get_chapter_map_file_path())
	SceneManager.replace_scene("Map")

# TEMP
func _on_credits_button_pressed() -> void:
	var credits_file = FileAccess.open("res://credits.txt", FileAccess.READ)
	if credits_file:
		var credits: String = credits_file.get_as_text()
		credits_file.close()
		
		credits_rich_text_label.text = "TEMP !!!!!!\n%s" % credits
		set_credits_visibility(true)

func _on_close_credits_button_pressed() -> void:
	set_credits_visibility(false)
