extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("cutscene")
	await animation_player.animation_finished
	await get_tree().create_timer(5.0).timeout
