extends Control
class_name LoadingAnimation

@onready var animation_path_follow: PathFollow2D = $AnimationSubViewport/AnimationPath/AnimationPathFollow

@export var autoplay: bool = false

var playing: bool = false
var loading_animation_duration: float = 5.0
var animation_tween

func _ready() -> void:
	if autoplay: play()

func play() -> void:
	animation_path_follow.progress_ratio = 0.0
	playing = true
	print("Playing Animation")
	
	if animation_tween: animation_tween.kill()
	animation_tween = get_tree().create_tween()
	animation_tween.set_ease(Tween.EASE_IN_OUT)
	animation_tween.set_trans(Tween.TRANS_BOUNCE)
	animation_tween.tween_property(
		animation_path_follow, "progress_ratio",
		1.0, loading_animation_duration
	)
	
	await animation_tween.finished
	if playing: play()

func stop() -> void:
	animation_tween.kill()
	playing = false
	print("Animation Stoped")
