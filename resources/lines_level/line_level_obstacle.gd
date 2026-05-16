extends Resource
class_name LineLevelObstacle

@export var type: Obstacle.TYPES = Obstacle.TYPES.BALL
@export_range(2.0, 2.1, 0.1, "hide_control", "or_greater") var value: float = 2.0
@export_range(1, 6) var line: int = 1
