extends Node3D
class_name Tablet

@onready var video_player: VideoPlayer = $CanvasLayer/VideoPlayer
@onready var mouse_hovering: MeshInstance3D = $MouseHovering
@onready var pickup_audio_stream_player: AudioStreamPlayer = $PickupAudioStreamPlayer

@export var video: VideoStream = null
@export var allow_mouse_hover: bool = true

var mouse_hover: bool = false

func _ready() -> void:
	mouse_hovering.hide()
	video_player.hide()
	set_video(video)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and mouse_hover:
		await get_tree().create_timer(0.5).timeout
		if video: GameManager.ground_tablet_clicked.emit(video)
		if allow_mouse_hover:
			pickup_audio_stream_player.play()
			queue_free()

func set_video(_video: VideoStream) -> void:
	video_player.video_stream = _video

func play_video() -> void:
	video_player.show()
	video_player.play()

func _on_video_player_video_finished() -> void:
	video_player.hide()


func _on_mouse_detection_area_mouse_entered() -> void:
	if allow_mouse_hover:
		mouse_hover = true
		mouse_hovering.show()

func _on_mouse_detection_area_mouse_exited() -> void:
	if allow_mouse_hover:
		mouse_hover = false
		mouse_hovering.hide()
