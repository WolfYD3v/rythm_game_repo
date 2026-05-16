extends Node
class_name LinesLevelObstacleGeneration

signal create_obstacles_call(obstacles: Array[LineLevelObstacle])

var timer: float = 0.0
var generation_timeout_duration: float = 0.05
var current_obstacle_set: LineLevelBbstaclesSet = null

func timer_up() -> void:
	timer = snappedf(timer + generation_timeout_duration, 0.01)
	if current_obstacle_set:
		if current_obstacle_set.at_time - 0.5 == timer:
			create_obstacles_call.emit(current_obstacle_set.obstacles)
	
	await get_tree().create_timer(generation_timeout_duration).timeout
	timer_up()

func start_generation(obstacle_sets: Array[LineLevelBbstaclesSet]) -> void:
	if obstacle_sets.is_empty():
		push_warning("Cannot generate obstales with a ampty collection, the player automatically survived the level.")
		get_parent().trigger_end(false)
	
	timer = 0.0
	timer_up()
	for _obstacle_set: LineLevelBbstaclesSet in obstacle_sets:
		current_obstacle_set = _obstacle_set
		await create_obstacles_call
