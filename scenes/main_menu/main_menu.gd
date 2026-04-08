extends Control
class_name MainMenu

@onready var hoyploma_sub_viewport: SubViewport = $HoyplomaSubViewport
@onready var credits_rich_text_label: RichTextLabel = $CreditsRichTextLabel
@onready var gui: Control = $GUI

const SETTINGS_PACKED_SCENE: PackedScene = preload("res://scenes/settings/settings.tscn")
const CONTEXT_PACKED_SCENE: PackedScene = preload("res://scenes/context/context.tscn")
const HOYPLOMA_PACKED_SCENE: PackedScene = preload("res://scenes/hoyploma/hoyploma.tscn")

func _ready() -> void:
	set_credits_visibility(false)
	SceneManager.add_scene("Hoyploma", HOYPLOMA_PACKED_SCENE)
	hoyploma_sub_viewport.add_child(
		SceneManager.get_scene("Hoyploma").instantiate()
	)

func set_credits_visibility(value: bool) -> void:
	credits_rich_text_label.visible = value
	gui.visible = not(value)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	SceneManager.add_scene("Settings", SETTINGS_PACKED_SCENE)
	SceneManager.replace_scene("Settings")

func _on_play_button_pressed() -> void:
	SceneManager.add_scene("Context", CONTEXT_PACKED_SCENE)
	SceneManager.replace_scene("Context")

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
