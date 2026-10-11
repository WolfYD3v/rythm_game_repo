extends CharacterBody3D
class_name Player

@onready var camera: Camera3D = $Camera

const JUMP_VELOCITY = 4.5

func _ready() -> void:
	pass

func _input(_event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

func walk() -> void:
	velocity.z += 0.2
