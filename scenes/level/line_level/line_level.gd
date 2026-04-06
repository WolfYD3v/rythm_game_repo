extends Node3D
class_name LineLevel

@export var ennemy_scene: PackedScene = null
@export var env_scene: PackedScene = null
@export var song: AudioStream = null

@onready var ennemy_node: Node3D = $Ennemy
@onready var lines: Node3D = $Lines
@onready var obstacles: Node3D = $Obstacles
@onready var player: MeshInstance3D = $Player
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var env_node: Node3D = $Env

var player_x_positions: Array[float] = []
var player_x_positions_idx: int = -1
var lines_map_count: int = 0

var player_tween

func _ready() -> void:
	try_load_level_data()
	try_set_level()
	
	# TEMP CODE
	var temp_mesh_instance_3d: MeshInstance3D = MeshInstance3D.new()
	var temp_box_mesh: BoxMesh = BoxMesh.new()
	temp_box_mesh.size = Vector3(2.0, 2.0, 2.0)
	temp_mesh_instance_3d.mesh = temp_box_mesh
	ennemy_node.add_child(temp_mesh_instance_3d)
	
	audio_stream_player.play(5.0)
	var player_x_position: float = player.position.x
	lines_map_count = lines.get_child_count()
	for loop: int in range(lines_map_count):
		player_x_positions.append(player_x_position)
		player_x_position += 3.0

func try_load_level_data() -> void:
	if LevelManager.level_data_to_be_used.is_empty(): return
	
	var level_data: Dictionary = LevelManager.level_data_to_be_used.duplicate()
	LevelManager.level_data_to_be_used = {}
	for variable_key: String in level_data.keys():
		var variable_value: Variant = level_data[variable_key]
		set(variable_key, variable_value)

func try_set_level() -> void:
	if ennemy_scene: ennemy_node.add_child(ennemy_scene.instantiate())
	if env_scene: env_node.add_child(env_scene.instantiate())
	if song: audio_stream_player.stream = song

func change_player_x_position(new_x_pos: float) -> void:
	var change_line_repetition: int = int((player.position.x - new_x_pos) / 3)
	print("Player moving %s lines" % change_line_repetition)
	if change_line_repetition < 0: change_line_repetition += change_line_repetition * -2
	
	var player_tween_duration: float = 0.1 * change_line_repetition
	
	if player_tween: player_tween.kill()
	player_tween = get_tree().create_tween()
	player_tween.set_ease(Tween.EASE_IN_OUT)
	player_tween.set_trans(Tween.TRANS_CUBIC)
	player_tween.tween_property(player, "position:x", new_x_pos, player_tween_duration)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("Tile1"): player_x_positions_idx = 0
		elif Input.is_action_just_pressed("Tile2"): player_x_positions_idx = 1
		elif Input.is_action_just_pressed("Tile3"): player_x_positions_idx = 2
		elif Input.is_action_just_pressed("Tile4"): player_x_positions_idx = 3
		elif Input.is_action_just_pressed("Tile5"): player_x_positions_idx = 4
		elif Input.is_action_just_pressed("Tile6"): player_x_positions_idx = 5
		else: player_x_positions_idx = -1
		
		if player_x_positions_idx > -1: change_player_x_position(
			player_x_positions[player_x_positions_idx]
		)
		$CanvasLayer/InputDoneLabel.text = "Input: %s" % event.as_text()

func _process(_delta: float) -> void:
	obstacles.position.z += 1.0
