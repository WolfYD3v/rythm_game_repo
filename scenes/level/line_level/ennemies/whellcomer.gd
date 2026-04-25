extends Node3D
class_name Whellcomer

signal dialog_line_finished

@onready var dialog_text_mesh: MeshInstance3D = $DialogSection/DialogTextMesh
@onready var dialog_voice_audio_stream_player_3d: AudioStreamPlayer3D = $DialogSection/DialogVoiceAudioStreamPlayer3D
@onready var model: Node3D = $Model
@onready var head: Node3D = $Model/MetalPlate1/MetalPlate2/MetalPlate3/MetalPlate4/MetalPlate5/MetalPlate6/MetalPlate7/MetalPlate8/MetalPlate9/MetalPlate10/MetalPlate11/Head
@onready var body_rotation_audio_stream_player_3d: AudioStreamPlayer3D = $BodyRotationAudioStreamPlayer3D
@onready var head_rotation_audio_stream_player_3d: AudioStreamPlayer3D = $HeadRotationAudioStreamPlayer3D

@export_range(2, 3, 1, "or_greater") var rotation_steps_count: int = 15
@export var rotation_value: float = -5
@export var min_rot_random_value: float = -15.0
@export var max_rot_random_value: float = 15.0
@export var random_rotation: bool = false

func _ready() -> void:
	say_dialog("res://dialogs/temp_dialog.json")
	
	await get_tree().create_timer(3.5).timeout
	call_deferred("rotate_body_part", model.get_child(0), rotation_value, "z", true, rotation_steps_count, random_rotation, true)
	turn_head(350.0, false)

func _process(_delta: float) -> void:
	for model_element: Node3D in $ModelElements.get_children():
		model_element.rotate_y(deg_to_rad(0.5))
		model_element.rotate_x(deg_to_rad(0.5))

func turn_head(rot: float, shaking: bool = false) -> void:
	call_deferred("rotate_body_part", head.get_child(0), rot, "z", false, 200, false, shaking)
	head_rotation_audio_stream_player_3d.play()

func rotate_body_part(body_part: Node3D, rot: float, axis: String, recursive: bool = true, steps_count: int = rotation_steps_count, random_rot: bool = random_rotation, shaking: bool = true) -> void:
	if body_part == null: return
	
	if random_rot: rot = randf_range(min_rot_random_value, max_rot_random_value)
	print("Rotating %s in %f degrees (random rotation: %s)..." % [body_part.name, rot, random_rot])
	
	var rot_value: float = deg_to_rad(rot / steps_count)
	for loop in range(steps_count):
		body_part.call("rotate_%s" % axis, rot_value)
		await get_tree().create_timer(0.02).timeout
	
	if body_part.get_child_count() == 1 and recursive:
		if body_part.get_child(0).name in ["Head", "Eye"]: return
		
		await get_tree().create_timer(0.03).timeout
		call_deferred("rotate_body_part", body_part.get_child(0), rot, axis, true, steps_count, random_rot, shaking)
	
	if shaking:
		for a in range(int(rotation_steps_count / 2)):
			body_part.call("rotate_%s" % axis, -rot_value)
			await get_tree().create_timer(0.01).timeout
		for b in range(int(rotation_steps_count / 2)):
			body_part.call("rotate_%s" % axis, rot_value)
			await get_tree().create_timer(0.01).timeout

func say_dialog(dialog_file_path: String) -> void:
	var dialog_file = FileAccess.open(dialog_file_path, FileAccess.READ)
	var lines: Array = JSON.parse_string(
		dialog_file.get_as_text()
	)
	dialog_file.close()
	
	for line: String in lines:
		write_dialog_line(line)
		await dialog_line_finished
		await get_tree().create_timer(1.5).timeout
	write_dialog_line(" ")

func write_dialog_line(text: String) -> void:
	dialog_text_mesh.mesh.text = ""
	for text_character: String in text:
		dialog_text_mesh.mesh.text += text_character
		dialog_voice_audio_stream_player_3d.pitch_scale = randf_range(
			0.3, 0.5
		)
		dialog_voice_audio_stream_player_3d.play()
		await get_tree().create_timer(0.05).timeout
	dialog_line_finished.emit()
