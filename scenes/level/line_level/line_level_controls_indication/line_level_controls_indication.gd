extends Node3D
class_name LineLevelControlsIndication

@onready var control_pads: Node3D = $Bar/ControlPads
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var jump_indicator_control: Node3D = $JumpIndicatorControl

var tween
var tween_duration: float = 0.5

func _ready() -> void:
	# Setup the controls indications
	var _line_count: int = 1
	for control_indication: Node3D in control_pads.get_children():
		if control_indication is not MeshInstance3D: continue
		
		control_indication.get_child(0).mesh.text = InputMap.action_get_events("LinesLevel_Line%d" % _line_count)[0].as_text()
		_line_count += 1
	# Disabled for now:
	#jump_indicator_control.get_node("JumpControlIndication").mesh.text = InputMap.action_get_events("LinesLevel_Jump")[0].as_text()
	#print(jump_indicator_control.get_node("JumpControlIndication").mesh.text)

func rotate_control_pads(rot_value: float, play_sfx: bool = true) -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		control_pads, "rotation:x",
		rot_value, tween_duration
	)
	
	if play_sfx:
		await get_tree().create_timer(0.1).timeout
		audio_stream_player_3d.play()
