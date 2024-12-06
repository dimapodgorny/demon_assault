extends Node2D
class_name Main

@onready var background: TextureRect = $Background


func _ready() -> void:
	$Background.call_deferred("set_size", get_viewport().size)
	$Background.position = -get_viewport().size / 2
