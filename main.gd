extends Node2D
class_name Main

@onready var background: TextureRect = $Background

func _ready() -> void:
	_update_debug()
	$Background.call_deferred("set_size", get_viewport().size)
	$Background.position = -get_viewport().size / 2
	
	
	

	
	
func _update_debug():
	$debug/VBoxContainer/PID.text += str(OS.get_process_id())
	


func _on_command_text_submitted(_new_text: String) -> void:
	$debug/VBoxContainer/command.placeholder_text = "cmd currently unavailable"
	$debug/VBoxContainer/command.deselect()
	$debug/VBoxContainer/command.clear()
	$debug/VBoxContainer/command.release_focus()
