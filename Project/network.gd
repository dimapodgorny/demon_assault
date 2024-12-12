extends Node
class_name NetworkHandler

## Export values
@export var PORT : int = 6005
@export var ADDRESS : String = "127.0.0.1"

@onready var Lobby: lobby = %Lobby

var networkPeer
var players_connected : Dictionary = { }
var clientID : int

@warning_ignore("unused_signal")
signal client_connected(id)
@warning_ignore("unused_signal")
signal client_disconnected(id)
@warning_ignore("unused_signal")
signal client_connection_failed(id)
@warning_ignore("unused_signal")
signal server_created
@warning_ignore("unused_signal")
signal server_closed
@warning_ignore("unused_signal")
signal server_creation_failed
@warning_ignore("unused_signal")
signal server_closing_peers_disconnected

@warning_ignore("unused_signal")
signal players_refreshed
@warning_ignore("unused_signal")
signal username_changed

var Player_A : int
var Player_B : int

var PlayersFighting : Dictionary = { }


@rpc("any_peer", "call_local", "reliable")
func set_Player_A_ID(ID : int):
	Player_A = ID

@rpc("any_peer", "call_local", "reliable")
func set_Player_B_ID(ID : int):
	Player_B = ID

	
func _ready() -> void:
	server_created.connect(update_peers)


## GENERAL NETWORKING
@rpc("any_peer", "call_local", "reliable")
func update_peers(_id = 1):
	_update_player_list.rpc()
	await players_refreshed
	Lobby.update_player_selection.rpc()
	players_refreshed.emit()
	
@rpc("any_peer", "call_local", "reliable")
func _update_player_list():
	players_connected = { }
	var newList = [ multiplayer.get_unique_id() ]
	var peers = multiplayer.get_peers()
	newList.append_array(peers)
	
	for newItem in newList:
		players_connected[newItem] = str(newItem)
	players_refreshed.emit()

@rpc("any_peer", "call_local", "reliable")
func _update_username(username : String):
	if username in players_connected.values():
		username = str(multiplayer.get_remote_sender_id())
	players_connected[multiplayer.get_remote_sender_id()] = username
	username_changed.emit()
	Lobby.update_player_selection.rpc()
	

## SERVER
func create_server(port : int = PORT):
	networkPeer = ENetMultiplayerPeer.new()
	var netErr = networkPeer.create_server(port)
	
	if netErr == OK:
		multiplayer.multiplayer_peer = networkPeer
		
		multiplayer.peer_connected.connect(update_peers)
		multiplayer.peer_disconnected.connect(update_peers)
		server_created.emit()
		
		call_deferred("update_peers")
	else:
		networkPeer = null
		printerr("Failed to create server: ", netErr)
		emit_signal("server_creation_failed")
	return netErr
		

func close_server():
	multiplayer.peer_connected.disconnect(update_peers)
	multiplayer.peer_disconnected.disconnect(update_peers)
	emit_signal("server_closed")
	

## CLIENT
func create_client(address = ADDRESS, port = PORT):
	networkPeer = ENetMultiplayerPeer.new()
	var netErr = networkPeer.create_client(address, port)
	
	if netErr == OK:
		multiplayer.multiplayer_peer = networkPeer
		emit_signal("client_connected")
	else:
		printerr("Error creating client: ", netErr)
		emit_signal("client_connection_failed")
	
	return netErr

func _on_client_disconnected(_id = 1):
	if is_multiplayer_authority():
		print("server disconnect")
		_disconnect_all_peers()
		multiplayer.multiplayer_peer = null
		networkPeer = null
		await server_closing_peers_disconnected
		close_server()
		
	else:
		print("client disconnect")
		_remove_peer.rpc( multiplayer.get_unique_id() )
		update_peers.rpc()
		await players_refreshed
		multiplayer.multiplayer_peer = null
		networkPeer = null
	
	players_connected = { }
	%Lobby.visible = false
	%MainMenu.visible = true
	
@rpc("any_peer", "call_remote", "reliable")
func _remove_peer(MyID):
	update_peers.rpc()
	players_connected.erase(MyID)
	client_disconnected.emit()

func _disconnect_all_peers():
	_remove_peer.rpc( multiplayer.get_unique_id() )
	players_connected = { }
	server_closing_peers_disconnected.emit()
	

func _on_username_button_pressed() -> void:
	_update_username.rpc($Node2D/Lobby/UsernameEdit.text)

func _on_username_edited(new_text: String) -> void:
	var _ID = multiplayer.get_unique_id()
	_update_username.rpc(new_text)
