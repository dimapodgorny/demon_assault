extends Node2D
class_name Main

@onready var background: TextureRect = $Background
@onready var camera: Camera2D = $Network/Node2D/Game/Camera

func _ready() -> void:
	$Background.call_deferred("set_size", get_viewport().size)
	$Background.position = -get_viewport().size / 2
	camera.position_changed.connect(follow_camera)

func follow_camera():
	$debug.global_position = camera.global_position - Vector2(576, 324)
