extends Control
class_name lobby

@onready var network: NetworkHandler = %Network
@onready var container: VBoxContainer = $players/ScrollContainer/VBoxContainer


func _ready() -> void:
	if owner is Main:
		self.visible = false
	
	ChallengeHandler.challenged.connect(ChallengePrompt)
	$ChallengePrompter.call_deferred("set_size", get_window().size)
	$ChallengePrompter.visible = false
	
#####################################################################
#####################################################################
#####################################################################
#####################################################################

@rpc("any_peer", "call_local", "reliable")
func update_player_selection():
	for child in container.get_children():
		if container.has_node(child.get_path()):
			container.remove_child(child)
			child.queue_free()
	
	for ChildID in network.players_connected:
		var playerLabel = preload("res://UI/player_slot.tscn").instantiate()
		playerLabel.name = str(ChildID)
		playerLabel.PlayerName = network.players_connected[ChildID]
		container.add_child(playerLabel)
		


func _on_back_to_menu_pressed() -> void:
	network._on_client_disconnected()
	%Lobby.visible = false
	%MainMenu.visible = true

func _on_accept_pressed() -> void:
	ChallengeHandler.accepted.emit()
	print.call_deferred("\n\n\n", ChallengeHandler.accepted.get_connections(), "\n\n\n")
	
	

func _on_decline_pressed() -> void:
	HidePrompts()
	HidePrompts.rpc_id(ChallengeHandler.Player_Challenging)
	ChallengeHandler.declined.emit()

func ChallengePrompt():
	$ChallengePrompter.visible = true
	$"ChallengePrompter/Getting Challenged".visible = true

	
@rpc("any_peer", "call_local", "reliable")
func HidePrompts() -> void:
	$ChallengePrompter.visible = false
	$"ChallengePrompter/Challenging Player".visible = false
	$"ChallengePrompter/Getting Challenged".visible = false
	
