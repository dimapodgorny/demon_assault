extends Control

func _ready() -> void:
	self.visible = false

@onready var network: NetworkHandler = %Network
@onready var container: VBoxContainer = $players/ScrollContainer/VBoxContainer

@rpc("any_peer", "call_local", "reliable")
func update_player_list():
	for child in container.get_children():
		container.call_deferred("remove_child", child)
		child.queue_free()
	

func _on_back_to_menu_pressed() -> void:
	network._on_client_disconnected()
	self.visible = false
	%MainMenu.visible = true
