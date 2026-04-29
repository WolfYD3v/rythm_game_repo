extends Node3D
class_name LineLevel

@export var ennemy_scene: PackedScene = null
@export var env_scene: PackedScene = null
@export var song: AudioStream = null
@export var obstacle_sets_array: Array[LineLevelBbstaclesSet]

@onready var ennemy_node: Node3D = $Ennemy
@onready var lines: Node3D = $Lines
@onready var obstacles_node: Node3D = $Obstacles
@onready var lines_level_player: LinesLevelPlayer = $LinesLevelPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var env_node: Node3D = $Env
@onready var new_obstacle_marker: Marker3D = $NewObstacleMarker
@onready var fading_black: ColorRect = $CanvasLayer/FadingBlack
@onready var line_level_controls_indication: LineLevelControlsIndication = $LineLevelControlsIndication
@onready var lines_level_health_bar: LinesLevelHealthBar = $CanvasLayer/LinesLevelHealthBar
@onready var lines_level_obstacle_generation: LinesLevelObstacleGeneration = $LinesLevelObstacleGeneration
@onready var loose_screen: LooseScreen = $CanvasLayer/LooseScreen

var line_level_controls_indication_tween

var obstacles_count: int = 0
var max_obstacles_count: int = 15
var obstacle_spawn_z_pos: float = 0.0

var ending: bool = false

func _ready() -> void:
	try_load_level_data()
	lines_level_health_bar.init_health_bar(obstacle_sets_array.size())
	lines_level_obstacle_generation.create_obstacles_call.connect(
		func(obstacles: Array[LineLevelObstacle]):
			lines_level_health_bar.lower(1)
			for _obstacle: LineLevelObstacle in obstacles:
				try_create_obstacle(_obstacle)
	)
	lines_level_health_bar.empty.connect(
		func(): trigger_end(false)
	)
	
	obstacle_spawn_z_pos = new_obstacle_marker.global_position.z
	obstacles_count = obstacles_node.get_child_count()
	
	# Black fading out transition
	fading_back_out()
	
	move_lines_level_controls_indication(-10.0, 5.5)
	await get_tree().create_timer(6.0).timeout
	line_level_controls_indication.turn_light(true)
	line_level_controls_indication.rotate_control_pads(0.0, true)
	await get_tree().create_timer(3.5).timeout
	line_level_controls_indication.turn_light(false)
	line_level_controls_indication.rotate_control_pads(-180.0, false)
	await get_tree().create_timer(0.1).timeout
	move_lines_level_controls_indication(-100.0, 15.0)
	lines_level_health_bar.popup()
	await get_tree().create_timer(3.5).timeout
	
	# Play the music, and start the recursive obstacles generation
	audio_stream_player.play()
	lines_level_obstacle_generation.start_generation(obstacle_sets_array)

func _process(_delta: float) -> void:
	for obstacle: Obstacle in obstacles_node.get_children():
		obstacle.global_position.z += 0.5

func move_lines_level_controls_indication(y_pos: float, duration: float) -> void:
	if line_level_controls_indication_tween: line_level_controls_indication_tween.kill()
	line_level_controls_indication_tween = get_tree().create_tween()
	
	line_level_controls_indication_tween.set_ease(Tween.EASE_OUT)
	line_level_controls_indication_tween.set_trans(Tween.TRANS_CIRC)
	line_level_controls_indication_tween.tween_property(
		line_level_controls_indication, "position:y",
		y_pos, duration
	)

func try_create_obstacle(obstacle_data: LineLevelObstacle) -> void:
	if obstacles_count + 1 > max_obstacles_count: return
	obstacles_count += 1
	
	# Create the obstacle
	var packed_obstacle: PackedScene = load("res://scenes/level/line_level/obstacles/obstacle.tscn")
	var new_obstacle: Obstacle = packed_obstacle.instantiate()
	new_obstacle.name = "Obstacle%d" % [obstacles_node.get_child_count() + 1]
	new_obstacle.player_touched.connect(
		func(): trigger_end(true)
	)
	
	# Set the position of the obstacle
	new_obstacle.position = Vector3(
		3.0 * (obstacle_data.line - 1), 0,
		obstacle_spawn_z_pos
	)
	
	# Add the obstacles to the scene tree
	obstacles_node.add_child(new_obstacle)
	new_obstacle.set_obstacle(obstacle_data)

func try_destroy_obstacle(obstacle: Node3D) -> void:
	if obstacles_count - 1 < 0: return
	obstacles_count -= 1
	
	obstacle.call_deferred("queue_free")

func try_load_level_data() -> void:
	if ennemy_scene: ennemy_node.add_child(ennemy_scene.instantiate())
	if env_scene: env_node.add_child(env_scene.instantiate())
	if song: audio_stream_player.stream = song
	# Obstacle sets

func _on_obstacle_destroy_area_area_entered(area: Area3D) -> void:
	if area is Obstacle:
		try_destroy_obstacle(area)
		lines_level_health_bar.empty.emit()

func fading_back_out() -> void:
	fading_black.modulate = Color(1.0, 1.0, 1.0, 1.0)
	fading_black.show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		fading_black, "modulate",
		Color(1.0, 1.0, 1.0, 0.0), 10.0
	)

func fading_back_in() -> void:
	fading_black.modulate = Color(1.0, 1.0, 1.0, 0.0)
	fading_black.show()
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		fading_black, "modulate",
		Color(1.0, 1.0, 1.0, 1.0), 5.0
	)

func trigger_end(player_killed: bool) -> void:
	if ending: return
	if not player_killed and obstacles_count > 0: return
	ending = true
	
	if player_killed:
		loose_screen.show()
		# Code ici ?
	else:
		fading_back_in()
		await get_tree().create_timer(7.0).timeout
		LevelManager.win()
