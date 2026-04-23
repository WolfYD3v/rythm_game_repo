extends Resource
class_name LineLevelObstacle

@export var type: Obstacle.TYPES = Obstacle.TYPES.BALL
@export_range(0.0, 0.1, 0.05, "hide_control", "or_greater") var value: float = 0.0
@export_range(1, 6) var line: int = 1
