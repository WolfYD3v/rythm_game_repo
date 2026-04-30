extends CharacterBody3D
class_name LinesLevelPlayer

@export var allow_inputs: bool = true
@export var jump_velocity: float = 5.0

var x_positions: Array[float] = []
var x_positions_idx: int = 0
var line_distance: float = 3.0
var tween

func _ready() -> void:
	var x_position: float = position.x
	for loop: int in range(6):
		x_positions.append(x_position)
		x_position += line_distance

func _input(event: InputEvent) -> void:
	if event is InputEventKey and allow_inputs and is_on_floor():
		if Input.is_action_just_pressed("LinesLevel_Left"): x_positions_idx = clampi(
			x_positions_idx - 1, 0, 5
		)
		elif Input.is_action_just_pressed("LinesLevel_Right"): x_positions_idx = clampi(
			x_positions_idx + 1, 0, 5
		)
		elif Input.is_action_just_pressed("LinesLevel_Line1"): x_positions_idx = 0
		elif Input.is_action_just_pressed("LinesLevel_Line2"): x_positions_idx = 1
		elif Input.is_action_just_pressed("LinesLevel_Line3"): x_positions_idx = 2
		elif Input.is_action_just_pressed("LinesLevel_Line4"): x_positions_idx = 3
		elif Input.is_action_just_pressed("LinesLevel_Line5"): x_positions_idx = 4
		elif Input.is_action_just_pressed("LinesLevel_Line6"): x_positions_idx = 5
		else: pass
		
		if x_positions_idx > -1: change_x_position(
			x_positions[x_positions_idx]
		)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("LinesLevel_Jump") and allow_inputs and is_on_floor():
		velocity.y = jump_velocity
	
	move_and_slide()

func change_x_position(new_x_pos: float) -> void:
	var change_line_repetition: int = int((position.x - new_x_pos) / 3)
	print("Player moving %s lines" % change_line_repetition)
	if change_line_repetition < 0: change_line_repetition += change_line_repetition * -2
	
	var player_tween_duration: float = 0.1 * change_line_repetition
	
	if tween: tween.kill()
	tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:x", new_x_pos, player_tween_duration)
