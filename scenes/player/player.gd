extends CharacterBody3D
class_name Player

signal input_released

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const JUMP_VELOCITY = 10.0

var moving: bool = false
var crouching: bool = false
var moving_tween
var moving_tween_time: float = 0.1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor(): velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor(): jump()
	
	move_and_slide()

func _input(_event: InputEvent) -> void:
	crouching = Input.is_action_pressed("crouch")
	if not crouching:
		if Input.is_action_pressed("crouch"): crouch()
		else: input_released.emit()

func change_position(new_position: Vector3) -> void:
	if new_position.x < position.x: animation_player.play("move_left")
	else: animation_player.play("move_right")
	
	moving = true
	await _tween_position(new_position)
	moving = false

func crouch() -> void:
	print("crouching")
	position.y -= 0.5
	await input_released
	position.y += 0.5

func jump() -> void:
	velocity.y = JUMP_VELOCITY

func _tween_position(new_position: Vector3) -> void:
	if moving_tween:
		moving_tween.kill()
	
	moving_tween = get_tree().create_tween()
	moving_tween.set_ease(Tween.EASE_IN_OUT)
	moving_tween.set_trans(Tween.TRANS_EXPO)
	moving_tween.tween_property(self, "position", new_position, moving_tween_time)
	await moving_tween.finished
