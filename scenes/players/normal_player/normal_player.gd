extends BasePlayer
class_name NormalPlayer

@onready var stamina_progress_bar: ProgressBar = $CanvasLayer/StaminaProgressBar

@export_category("Movement Section")
@export_group("Speed Managment")
@export_range(4.5, 4.51, 0.01, "or_greater", "hide_control") var base_speed: float = 3.0
@export_range(1.65, 1.66, 0.01, "or_greater", "hide_control") var running_speed_factor: float = 1.65
@export_range(0.05, 0.95, 0.01) var already_tired_at_stamina_pourcentage = 0.05
@export_range(0.05, 0.95, 0.01) var full_energy_at_stamina_pourcentage = 0.95

@export_range(0.05, 0.55, 0.01, "hide_control") var tired_speed_factor: float = 0.2
@export_group("Jump Managment")
@export_range(4.5, 4.51, 0.01, "or_greater", "hide_control") var jump_velocity = 4.5
@export_category("Stamina Section")
@export_range(100.0, 101.0, 1.0, "or_greater", "hide_control") var max_stamina: float = 850.0
@export_range(1.0, 1.1, 0.1, "or_greater", "hide_control") var stamina_gain: float = 1.5
@export_range(1.0, 1.1, 0.1, "or_greater", "hide_control") var stamina_lose: float = 1.0

var direction: Vector3 = Vector3.ZERO
var on_edge: bool = false
var tired: bool = false
var speed: float = 0.0

var max_stamina_value_for_full_run_idk_guyz: float = 0.0
var min_stamina_value_for_full_run_idk_guyz: float = 0.0

func _ready() -> void:
	max_stamina_value_for_full_run_idk_guyz = full_energy_at_stamina_pourcentage * max_stamina
	min_stamina_value_for_full_run_idk_guyz = already_tired_at_stamina_pourcentage * max_stamina
	
	stamina_progress_bar.max_value = max_stamina
	update_stamina_bar(max_stamina)

func _input(_event: InputEvent) -> void: pass

func _physics_process(delta: float) -> void:
	# Handle gravity
	if not is_on_floor(): velocity += get_gravity() * delta
	
	# Handle jump related actions, if not tired
	if Input.is_action_just_pressed("Player_Jump") and !tired:
		if !on_edge and is_on_floor(): jump() # Jump from the ground
		elif on_edge: pass                    # Climb back from an edge
	
	set_speed()
	# Handle the mouvements
	var input_dir := Input.get_vector("Player_MoveLeft", "Player_MoveRight", "Player_MoveUp", "Player_MoveDown")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	update_stamina() # Update stamina bar after an action that can consume stamina has maybe been done
	move_and_slide()

func jump() -> void:
	var new_stamina: float = stamina_progress_bar.value - max_stamina / 15.0
	if Input.is_action_pressed("Player_RunToggled") and !tired:
		velocity.y = jump_velocity * 1.25
		new_stamina /= 1.05
	else: velocity.y = jump_velocity
	update_stamina_bar(new_stamina)

func is_moving() -> bool: return direction != Vector3.ZERO
func is_running() -> bool: return Input.is_action_pressed("Player_RunToggled") and is_moving() and is_on_floor() and !tired

func set_speed() -> void:
	if tired: speed = base_speed * tired_speed_factor
	elif is_running():
		if stamina_progress_bar.value >= max_stamina_value_for_full_run_idk_guyz: speed = base_speed * running_speed_factor
		elif stamina_progress_bar.value >= min_stamina_value_for_full_run_idk_guyz: _calculate_interpolated_speed(min_stamina_value_for_full_run_idk_guyz, max_stamina_value_for_full_run_idk_guyz)
		else: speed = base_speed * tired_speed_factor
	else: speed = base_speed
	if speed == base_speed * tired_speed_factor: tired = true
	print("Current Player Speed: %f" % speed)

func _calculate_interpolated_speed(_min_stamina: float, _max_stamina: float) -> void:
	var p = (stamina_progress_bar.value - _min_stamina) / (_max_stamina - _min_stamina)
	var f = tired_speed_factor + p * (running_speed_factor - tired_speed_factor)
	speed = base_speed * f

func update_stamina_bar(value: float) -> void: stamina_progress_bar.value = value

func update_stamina() -> void:
	var new_stamina: float = stamina_progress_bar.value
	if is_running():
		new_stamina -= stamina_lose
		if new_stamina <= 0.0: tired = true
	else:
		var current_stamina_gain: float = 0.0
		
		if is_moving() and is_on_floor(): current_stamina_gain = stamina_gain / 5.5
		elif !is_on_floor(): current_stamina_gain = stamina_gain / 7.5
		else: current_stamina_gain = stamina_gain
		new_stamina += current_stamina_gain
		
		if new_stamina >= max_stamina_value_for_full_run_idk_guyz: tired = false
	
	update_stamina_bar(new_stamina)
