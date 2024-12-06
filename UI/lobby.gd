extends Control
class_name lobby

func _input(event: InputEvent) -> void:
	if !owner is Main:
		if event is InputEventKey && KEY_0:
			update_player_selection()

func _ready() -> void:
	if owner is Main:
		self.visible = false

@onready var network: NetworkHandler = %Network
@onready var container: VBoxContainer = $players/ScrollContainer/VBoxContainer

@rpc("any_peer", "call_local", "reliable")
func update_player_selection():
	for child in container.get_children():
		container.call_deferred("remove_child", child)
		child.queue_free()
	
	for ChildID in network.players_connected:
		var playerLabel = preload("res://UI/player_slot.tscn").instantiate()
		playerLabel.name = ChildID
		playerLabel.PlayerName = network.players_connected[ChildID]
		container.add_child(playerLabel)
		

func _on_back_to_menu_pressed() -> void:
	network._on_client_disconnected()
	self.visible = false
	%MainMenu.visible = true
