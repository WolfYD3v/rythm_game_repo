extends Control
class_name SoundWave

@export var background_color: Color = Color(0.0, 0.0, 0.0)
@export_range(5, 45, 1, "prefer_slider") var num_bars: int = 30  # Number of frequency bands to display
@export var shuffle_freq = false
@export var flip_y = false

@onready var background: ColorRect = $Background

const MAX_FREQ = 1000  # Frequency range to analyze

var spectrum_instance
var bars = []
var color_gradient := Gradient.new()  # Dynamic color transitions

func _ready():
	background.color = background_color
	scale = Vector2(1.0, 1.0)
	color_gradient.add_point(0.0, Color(0.506, 0.114, 0.067))
	color_gradient.add_point(0.3, Color(0.602, 0.144, 0.089, 1.0))
	color_gradient.add_point(0.7, Color(0.727, 0.186, 0.12, 1.0))
	color_gradient.add_point(0.85, Color(0.85, 0.238, 0.162, 1.0))
	color_gradient.add_point(1.0, Color(0.939, 0.319, 0.237, 1.0))
	spectrum_instance = AudioServer.get_bus_effect_instance(1, 0)
	create_bars()

func create_bars():
	var bar_width: float = 0.0
	for i in range(num_bars):
		var bar = ColorRect.new()
		bar.color = Color(0.506, 0.114, 0.067)
		bar_width = size.x / num_bars
		bar.size = Vector2(bar_width, size.y)
		bar.position = Vector2(i * bar_width, size.y)
		add_child(bar)
		bars.append(bar)

func _process(_delta):
	if not spectrum_instance:
		return
	var max_freq_amp = bars.reduce(func(m, b): return b if b.size.y > m.size.y else m).size.y 
	
	for i in range(num_bars):
		var freq_start = (i * MAX_FREQ) / num_bars
		var freq_end = ((i + 1) * MAX_FREQ) / num_bars
		var magnitude = spectrum_instance.get_magnitude_for_frequency_range(freq_start, freq_end).length()
		bars[i].size.y = lerp(bars[i].size.y, magnitude * 1000 * 2, 0.2)  # Smooth animation
		
		var intensity = (magnitude*1000) / (max_freq_amp * 1000.0) if max_freq_amp > 0 else 0.0
		intensity *= 1000
		intensity = clamp(intensity, 0.0, 1.0)  # Keep within valid range
		LevelManager.current_intensity = intensity

		# Get dynamic color from gradient
		var new_color = color_gradient.sample(intensity)
		bars[i].color = new_color
		if flip_y:
			bars[i].scale.y = -1
	
	if shuffle_freq:
			bars.shuffle()
