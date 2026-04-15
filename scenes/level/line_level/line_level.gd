extends Node3D
class_name LineLevel

@export var ennemy_scene: PackedScene = null
@export var env_scene: PackedScene = null
@export var song: AudioStream = null
@export var obstacles_dict: Dictionary[String, float] = {}

@onready var ennemy_node: Node3D = $Ennemy
@onready var lines: Node3D = $Lines
@onready var obstacles_node: Node3D = $Obstacles
@onready var player: MeshInstance3D = $Player
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var env_node: Node3D = $Env
@onready var new_obstacle_marker: Marker3D = $NewObstacleMarker

@onready var controls_indication: Control = $CanvasLayer/ControlsIndication

var player_x_positions: Array[float] = []
var player_x_positions_idx: int = -1

var player_tween

var obstacles_count: int = 0
var max_obstacles_count: int = 15
var obstacle_spawn_z_pos: float = 0.0

var line_distance: float = 3.0

func _ready() -> void:
	controls_indication.get_node("ControlsIndicationRichTextLabel").text = "Controls: [b]%s%s%s%s%s%s[/b]" % [
		InputMap.action_get_events("LinesLevel_Line1")[0].as_text(),
		InputMap.action_get_events("LinesLevel_Line2")[0].as_text(),
		InputMap.action_get_events("LinesLevel_Line3")[0].as_text(),
		InputMap.action_get_events("LinesLevel_Line4")[0].as_text(),
		InputMap.action_get_events("LinesLevel_Line5")[0].as_text(),
		InputMap.action_get_events("LinesLevel_Line6")[0].as_text()
	]
	
	obstacle_spawn_z_pos = new_obstacle_marker.global_position.z
	obstacles_count = obstacles_node.get_child_count()
	setup_player_x_positions()
	try_load_level_data()
	
	audio_stream_player.play()
	try_gen(0.0)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("LinesLevel_Line1"): player_x_positions_idx = 0
		elif Input.is_action_just_pressed("LinesLevel_Line2"):player_x_positions_idx = 1
		elif Input.is_action_just_pressed("LinesLevel_Line3"): player_x_positions_idx = 2
		elif Input.is_action_just_pressed("LinesLevel_Line4"): player_x_positions_idx = 3
		elif Input.is_action_just_pressed("LinesLevel_Line5"): player_x_positions_idx = 4
		elif Input.is_action_just_pressed("LinesLevel_Line6"): player_x_positions_idx = 5
		else: player_x_positions_idx = -1
		
		if player_x_positions_idx > -1: change_player_x_position(
			player_x_positions[player_x_positions_idx]
		)

func _process(_delta: float) -> void:
	for obstacle: Obstacle in obstacles_node.get_children():
		obstacle.global_position.z += 1.0

func try_gen(timer: float = 0.0) -> void:
	timer = snappedf(timer + 0.05, 0.05)
	
	if timer in obstacles_dict.values(): try_create_obstacle(
		randi_range(1, 6)
	)
	
	await get_tree().create_timer(0.05).timeout
	try_gen(timer)

func setup_player_x_positions() -> void:
	var x_position: float = player.position.x
	var lines_map_count: int = lines.get_child_count()
	for loop: int in range(lines_map_count):
		player_x_positions.append(x_position)
		x_position += line_distance

func try_create_obstacle(at_line: int) -> void:
	if obstacles_count + 1 > max_obstacles_count: return
	obstacles_count += 1
	
	# Create the obstacle
	var packed_obstacle: PackedScene = load("res://scenes/level/line_level/obstacles/obstacle.tscn")
	var new_obstacle: Obstacle = packed_obstacle.instantiate()
	new_obstacle.name = "Obstacle%d" % [obstacles_node.get_child_count() + 1]
	
	# Set the position of the obstacle
	new_obstacle.position = Vector3(
		line_distance * (at_line - 1), 0,
		obstacle_spawn_z_pos
	)
	
	# Add the obstacles to the scene tree
	obstacles_node.add_child(new_obstacle)
	$CanvasLayer/Label.text = "Obstacle created: %s at line %d" % [new_obstacle, at_line]

func try_destroy_obstacle(obstacle: Node3D) -> void:
	if obstacles_count - 1 < 0: return
	obstacles_count -= 1
	
	$CanvasLayer/Label.text = "Obstacle destroyed: %s" % obstacle
	obstacle.call_deferred("queue_free")

func try_load_level_data() -> void:
	if LevelManager.ennemy_scene: ennemy_scene = LevelManager.ennemy_scene
	if LevelManager.env_scene: env_scene = LevelManager.env_scene
	if LevelManager.song: song = LevelManager.song
	if not LevelManager.obstacles_dict.is_empty(): obstacles_dict = LevelManager.obstacles_dict
	
	if ennemy_scene: ennemy_node.add_child(ennemy_scene.instantiate())
	if env_scene: env_node.add_child(env_scene.instantiate())
	if song: audio_stream_player.stream = song
	
	# TEMP
	if obstacles_dict.is_empty(): return
	for obsctacle_name: String in obstacles_dict.keys():
		print("Obstacle '%s' -> %f" % [obsctacle_name, obstacles_dict.get(obsctacle_name)])

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

func _on_obstacle_destroy_area_area_entered(area: Area3D) -> void:
	if area is Obstacle: try_destroy_obstacle(area)
