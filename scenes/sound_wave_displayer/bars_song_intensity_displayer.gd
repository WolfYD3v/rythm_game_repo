extends HBoxContainer
class_name SoundWaveDisplayer

enum ANIMATION_ORDERINGS {
	BEGIN,
	END,
	RANDOM
}

@export_range(1, 45, 1, "prefer_slider") var num_bars: int = 30  # Number of frequency bands to display
@export var animation_ordering: ANIMATION_ORDERINGS = ANIMATION_ORDERINGS.BEGIN
@export var flip_y = false

var bars: Array = []
var bars_idx: int = 0

func _ready() -> void:
	create_bars()
	SoundIntensityUtil.intensity_calculated.connect(process_song_intensity)

func create_bars():
	for i in range(num_bars):
		var bar: ColorRect = ColorRect.new()
		bar.color = Color(0.043, 0.043, 0.043, 1.0)
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if flip_y: bar.size_flags_vertical = Control.SIZE_SHRINK_END
		else: bar.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		
		add_child(bar)
		bars.append(bar)
	
	if animation_ordering == ANIMATION_ORDERINGS.END: bars.reverse()
	if animation_ordering == ANIMATION_ORDERINGS.RANDOM: bars.shuffle()

func process_song_intensity(data) -> void:
	var max_freq_amp = bars.reduce(func(m, b): return b if b.size.y > m.size.y else m).size.y 
	
	for i in range(num_bars):
		if i != bars_idx: continue
		
		bars[i].size.y = clampi(lerp(bars[i].size.y, data[1] * 1000 * 2, 0.2), 0.0, size.y)  # Smooth animation
		
		var intensity = (data[1] * 1000) / (max_freq_amp * 1000.0) if max_freq_amp > 0 else 0.0
		intensity *= 1000
		intensity = clamp(intensity, 0.0, 1.0)  # Keep within valid range
		intensity = snappedf(intensity, 0.01)
		
		if flip_y: bars[i].scale.y = -1
	
	if animation_ordering == ANIMATION_ORDERINGS.RANDOM: bars.shuffle()
	else:
		bars_idx += 1
		if bars_idx > bars.size() - 1: bars_idx = 0
