extends CharacterBody3D
class_name Player

@onready var camera: Node3D = $CameraPivot/Camera
@onready var stamina_progress_bar: ProgressBar = $CanvasLayer/StaminaProgressBar

@export_category("Movement Section")
@export_group("Speed Managment")
@export_range(4.5, 4.51, 0.01, "or_greater", "hide_control") var base_speed: float = 4.5
@export_range(1.65, 1.66, 0.01, "or_greater", "hide_control") var running_speed_factor: float = 1.65
@export_range(0.05, 0.55, 0.01, "hide_control") var tired_speed_factor: float = 0.2
@export_group("Jump Managment")
@export_range(4.5, 4.51, 0.01, "or_greater", "hide_control") var jump_velocity = 4.5
@export_category("Stamina Section")
@export_range(100.0, 101.0, 1.0, "or_greater", "hide_control") var max_stamina: float = 550.0
@export_range(1.0, 1.1, 0.1, "or_greater", "hide_control") var stamina_gain: float = 1.0
@export_range(1.0, 1.1, 0.1, "or_greater", "hide_control") var stamina_lose: float = 1.0

var direction: Vector3 = Vector3.ZERO
var on_edge: bool = false
var tired: bool = false
var speed: float = 0.0

func _ready() -> void:
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
	speed = base_speed
	if is_running(): speed *= running_speed_factor
	if tired: speed *= tired_speed_factor
	print("Current Player Speed: %f" % speed)

func update_stamina_bar(value: float) -> void: stamina_progress_bar.value = value

func update_stamina() -> void:
	var new_stamina: float = stamina_progress_bar.value
	if is_running():
		new_stamina -= stamina_lose
		if new_stamina <= 0.0: tired = true
	else:
		if is_moving() and is_on_floor(): new_stamina += stamina_gain / 5.5
		elif !is_on_floor(): new_stamina += stamina_gain / 7.5
		else: new_stamina += stamina_gain
		if new_stamina >= max_stamina and tired: tired = false
	
	update_stamina_bar(new_stamina)
