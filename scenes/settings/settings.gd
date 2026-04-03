extends Control
class_name Settings

@onready var listen_sample_check_button: CheckButton = $InterfaceContainer/SettingsContainer/SectionsContainer/AudioSectionContainer/ListenSampleCheckButton

func _ready() -> void:
	setup_interface()

func setup_interface() -> void:
	SettingsManager.get_settings()
	listen_sample_check_button.button_pressed = SettingsManager.listen_samples

func set_language(language: String) -> void:
	SettingsManager.language = language
	TranslationServer.set_locale(language)

func _on_listen_sample_check_button_toggled(toggled_on: bool) -> void:
	SettingsManager.listen_samples = toggled_on

func _on_close_button_pressed() -> void:
	SettingsManager.save_settings_file()
	SceneManager.replace_scene("MainMenu")

func _on_save_button_pressed() -> void:
	SettingsManager.save_settings_file()
