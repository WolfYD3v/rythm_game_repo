extends Node
class_name SongIntensityUtil

signal intensity_calculated(data: Array)

const MAX_FREQ = 1000  # Frequency range to analyze
const MAX_MAGNITUDE_REFERENCE: float = 0.5

var spectrum_instance: AudioEffectInstance
var timer: float = 0.0

func _ready():
	spectrum_instance = AudioServer.get_bus_effect_instance(1, 0)

func up_timer() -> void:
	timer = snappedf(timer + 0.05, 0.01)
	await get_tree().create_timer(0.05).timeout
	up_timer()

func _process(_delta):
	if not spectrum_instance: return

	# On calcule la magnitude sur TOUTE la plage de fréquence en une seule fois
	var magnitude = spectrum_instance.get_magnitude_for_frequency_range(0, MAX_FREQ).length()
	
	var intensity = magnitude / MAX_MAGNITUDE_REFERENCE
	intensity = clamp(intensity, 0.0, 1.0)
	intensity = snappedf(intensity, 0.01)
	
	intensity_calculated.emit([timer, intensity])
