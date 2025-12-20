extends Node3D
class_name Level

@onready var lines: Node3D = $Lines
@onready var world: Node3D = $World
@onready var obstacles: Node3D = $Obstacles
@onready var player: Node3D = $Player

const LINE = preload("uid://cvmkpmy46b1n3")

var level_data: Dictionary = {}

var nb_lines: int = 0
var line_position: Vector3 = Vector3.ZERO
var player_line_idx: int = 1

func _ready() -> void:
	build_level("")

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_LEFT):
		if player_line_idx - 1 > 0:
			player.position.x -= 1.0
			player_line_idx -= 1
	if Input.is_key_pressed(KEY_RIGHT):
		if player_line_idx + 1 <= nb_lines:
			player.position.x += 1.0
			player_line_idx += 1
	if Input.is_key_pressed(KEY_DOWN):
		player.position.y = 0.5
	else:
		player.position.y = 1.0
	if Input.is_key_pressed(KEY_UP):
		player.position.y = 1.5
	else:
		player.position.y = 1.0

func build_level(_level_file_path: String) -> void:
	# Load level data
	var _level_data: Dictionary = LevelManager.load_level()
	level_data = _level_data
	
	# Fetch the number of lines of the level from the loaded level data
	nb_lines = int(level_data.get("lines"))
	print(nb_lines)
	
	# Generate the lines
	for line_idx: int in range(nb_lines):
		var _line: MeshInstance3D = LINE.instantiate()
		lines.add_child(_line)
		_line.position = line_position
		
		line_position.x += _line.mesh.size.x
	
	# Set the player postion
	player_line_idx = int(nb_lines / 2)
	player.position.x = lines.get_child(player_line_idx - 1).position.x
	print(player_line_idx)
