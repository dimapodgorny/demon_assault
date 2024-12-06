extends Node
class_name NetworkHandler

## Export values
@export var PORT : int = 6005
@export var ADDRESS : String = "127.0.0.1"

@onready var Lobby: lobby = %Lobby


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

func _init() -> void:
	pass
	
func _ready() -> void:
	server_created.connect(update_peers)
	client_connected.connect(Global.nothing)
	client_connection_failed.connect(Global.nothing)


## GENERAL
func update_peers(_id = 1):
	_update_player_list.rpc()
	await players_refreshed
	Lobby.update_player_selection.rpc()
	

@rpc("any_peer", "call_local", "reliable")
func _update_player_list():
	var newList = [(multiplayer.get_unique_id())]
	var peers = multiplayer.get_peers()
	newList.append_array(peers)
	
	for newItem in newList:
		players_connected[str(newItem)] = str(newItem)
	$"../debug/VBoxContainer/Connected Peers".text = "Connected Peers: " + str(players_connected)
	players_refreshed.emit()
	
	

## SERVER
func create_server(port : int = PORT):
	var networkPeer = ENetMultiplayerPeer.new()
	var netErr = networkPeer.create_server(port)
	
	if netErr == OK:
		multiplayer.multiplayer_peer = networkPeer
		multiplayer.peer_connected.connect(update_peers)
		multiplayer.peer_disconnected.connect(update_peers)
		multiplayer.peer_disconnected.connect(_on_client_disconnected)
		server_created.emit()
		$"../debug/VBoxContainer/Client_ID".text = "Client ID: " + str(multiplayer.get_unique_id())
		
		call_deferred("update_peers")
	else:
		printerr("Failed to create server: ", netErr)
		emit_signal("server_creation_failed")
		
	return netErr
		

func close_server():
	multiplayer.multiplayer_peer = null
	
		
	multiplayer.peer_connected.disconnect(update_peers)
	multiplayer.peer_disconnected.disconnect(update_peers)
	multiplayer.peer_disconnected.disconnect(_on_client_disconnected)

	emit_signal("server_closed")
	

## CLIENT
func create_client(address = ADDRESS, port = PORT):
	var networkPeer = ENetMultiplayerPeer.new()
	var netErr = networkPeer.create_client(address, port)
	
	if netErr == OK:
		multiplayer.multiplayer_peer = networkPeer
		emit_signal("client_connected")
		$"../debug/VBoxContainer/Client_ID".text = "Client ID: " + str(multiplayer.get_unique_id())
	else:
		printerr("Error creating client: ", netErr)
		emit_signal("client_connection_failed")
	
	return netErr

func _on_client_disconnected(_id = 1):
	if is_multiplayer_authority():
		print("server disconnect")
		_disconnect_all_peers.rpc()
		players_connected = {}
		$"../debug/VBoxContainer/Connected Peers".text = "Connected Peers: n/a"
		await server_closing_peers_disconnected
		close_server()
	else:
		print("client disconnect")
		players_connected = {}
		$"../debug/VBoxContainer/Connected Peers".text = "Connected Peers: n/a"
		multiplayer.multiplayer_peer = null
		update_peers()
		client_disconnected.emit()
	

@rpc("authority", "call_remote", "reliable")
func _disconnect_all_peers():
	%Lobby.visible = false
	%MainMenu.visible = true
	multiplayer.multiplayer_peer = null
	server_closing_peers_disconnected.emit()
	
