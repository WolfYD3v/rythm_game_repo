extends CharacterBody3D
class_name Player

signal look_at_map_changed

@onready var camera: Camera3D = $Camera
@onready var map: MeshInstance3D = $Arm/Map
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tablet: Tablet = $Tablet

@export var can_move_free_roam: bool = true
@export var can_jump: bool = true
@export var full_rotation: bool = true

const JUMP_VELOCITY = 4.5

var look_at_map: bool = false:
	set(value):
		look_at_map = value
		look_at_map_changed.emit()
var animation_played: bool = false

func _ready() -> void:
	GameManager.ground_tablet_clicked.connect(
		func(video: VideoStream):
			tablet.set_video(video)
			animation_played = not(animation_played)
			tablet.visible = animation_played
			if animation_played: animation_player.play("tablet_on")
			else: animation_player.play("tablet_on")
	)
	tablet.hide()
	map.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("ToggleMap"):
			if not animation_played:
				look_at_map = not(look_at_map)
				play_map_animation()
		if Input.is_key_pressed(KEY_LEFT): turn_around(0.05, "y")
		if Input.is_key_pressed(KEY_RIGHT): turn_around(-0.05, "y")
		if not look_at_map:
			if Input.is_key_pressed(KEY_UP): walk()
			if Input.is_key_pressed(KEY_DOWN): walk()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_jump:
		velocity.y = JUMP_VELOCITY

	move_and_slide()

func turn_around(rotation_value: float, axis: String) -> void:
	call("rotate_%s" % axis, rotation_value)
	if not full_rotation:
		rotation_degrees.x = clampf(rotation_degrees.x, 0.0, 10.0)
		rotation_degrees.y = clampf(rotation_degrees.y, -50.0, 50.0)
		#rotation_degrees.z = clampf(rotation_degrees.z, -5.0, 5.0)

func walk() -> void:
	if not can_move_free_roam: return
	
	velocity.z += 0.2

func play_map_animation() -> void:
	animation_played = true
	if look_at_map: animation_player.play("yes_look_map")
	else: animation_player.play("not_look_map")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	animation_played = false
