extends CharacterBody3D
class_name BasePlayer

@onready var camera: Node3D = $CameraPivot/Camera
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void: pass

func play_animation(animation_name: String) -> void:
	if animation_player.has_animation(animation_name): animation_player.play(animation_name)
