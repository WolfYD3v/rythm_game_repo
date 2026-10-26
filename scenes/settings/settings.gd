extends Node3D
class_name Settings

@onready var listen_sample_check_button: CheckButton = $CanvasLayer/InterfaceContainer/SettingsContainer/MarginContainer/VBoxContainer/SectionsContainer/AudioSectionContainer/ListenSampleCheckButton
@onready var fullscreen_check_button: CheckButton = $CanvasLayer/InterfaceContainer/SettingsContainer/MarginContainer/VBoxContainer/SectionsContainer/VideoSectionContainer/FullscreenCheckButton

@export var pause_menu_mode: bool = false

func _ready() -> void: setup_interface()

func setup_interface() -> void:
	SettingsManager.get_settings()
	listen_sample_check_button.button_pressed = SettingsManager.listen_samples
	fullscreen_check_button.button_pressed = SettingsManager.fullscreen

func set_language(language: String) -> void:
	SettingsManager.language = language
	TranslationServer.set_locale(language)

func _on_listen_sample_check_button_toggled(toggled_on: bool) -> void:
	SettingsManager.listen_samples = toggled_on

func _on_close_button_pressed() -> void:
	SettingsManager.save_settings_file()
	
	if not pause_menu_mode: SceneManager.replace_scene("MainMenu")
	else: hide()

func _on_fullscreen_check_button_toggled(toggled_on: bool) -> void:
	SettingsManager.fullscreen = toggled_on
	
	if toggled_on: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _on_reset_button_pressed() -> void:
	SettingsManager.reset_settings()
	setup_interface()

func _on_reset_save_button_pressed() -> void:
	SaveManager.reset()
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()
