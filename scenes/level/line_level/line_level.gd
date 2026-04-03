extends Node3D
class_name LineLevel

@export var env_scene: PackedScene = null
@export var song: AudioStream = null

@onready var map: Node3D = $Map
@onready var player: MeshInstance3D = $Map/Player
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var env_node: Node3D = $Map/Env

var player_x_positions: Array[float] = []
var lines_map_count: int = 0

func _ready() -> void:
	try_load_level_data()
	set_env()
	set_song()
	
	audio_stream_player.play(5.0)
	map.position = Vector3.ZERO
	var player_x_position: float = player.position.x
	lines_map_count = map.get_child_count()
	for loop: int in range(lines_map_count):
		player_x_positions.append(player_x_position)
		player_x_position += 3
	player.position.x = player_x_positions[
		int(lines_map_count / 2) - 1
	]

func try_load_level_data() -> void:
	if LevelManager.level_data_to_be_used.is_empty(): return
	
	var level_data: Dictionary = LevelManager.level_data_to_be_used.duplicate()
	LevelManager.level_data_to_be_used = {}
	for variable_key: String in level_data.keys():
		var variable_value: Variant = level_data[variable_key]
		set(variable_key, variable_value)

func set_env() -> void:
	if env_scene: env_node.add_child(
		env_scene.instantiate()
	)

func set_song() -> void:
	if song: audio_stream_player.stream = song

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("Tile1"): player.position.x = player_x_positions[0]
		elif Input.is_action_just_pressed("Tile2"): player.position.x = player_x_positions[1]
		elif Input.is_action_just_pressed("Tile3"): player.position.x = player_x_positions[2]
		elif Input.is_action_just_pressed("Tile4"): player.position.x = player_x_positions[3]
		elif Input.is_action_just_pressed("Tile5"): player.position.x = player_x_positions[4]
		elif Input.is_action_just_pressed("Tile6"): player.position.x = player_x_positions[5]
		else: pass
		$CanvasLayer/Label.text = "Input: %s" % event.as_text()

func _process(_delta: float) -> void:
	map.position.z -= 1.0
