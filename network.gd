extends Node
class_name NetworkHandler

## Export values
@export var PORT : int = 6005
@export var ADDRESS : String = "127.0.0.1"

@onready var lobby: Control = %Lobby

var players_connected : Dictionary = { }
var clientID : int

signal client_connected(id)
signal client_disconnected(id)
signal client_connection_failed(id)

signal server_created
signal server_closed
signal server_creation_failed
signal server_closing_peers_disconnected

signal players_refreshed

func _init() -> void:
	pass
	
func _ready() -> void:
	pass
	


## GENERAL
func update_peers(id = 1):
	_update_player_list.rpc()
	await players_refreshed
	lobby.update_player_list.rpc()
	$"../debug/VBoxContainer/Connected Peers".text = str("Connected Peers:", players_connected)


@rpc("any_peer", "call_local", "reliable")
func _update_player_list():
	var newList = [(multiplayer.get_unique_id())]
	var peers = multiplayer.get_peers()
	newList.append_array(peers)
	
	for newItem in newList:
		players_connected[str(newItem)] = str(newItem)
	
	players_refreshed.emit()
	

## SERVER
func create_server(port : int = PORT):
	var networkPeer = ENetMultiplayerPeer.new()
	var netErr = networkPeer.create_server(port)
	
	if netErr == OK:
		emit_signal("server_created")
		multiplayer.multiplayer_peer = networkPeer
		multiplayer.peer_connected.connect(update_peers)
		multiplayer.peer_disconnected.connect(update_peers)
		multiplayer.peer_disconnected.connect(_on_client_disconnected)
	else:
		printerr("Failed to create server: ", netErr)
		emit_signal("server_creation_failed")
		
	call_deferred("update_peers")
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
	else:
		printerr("Error creating client: ", netErr)
		emit_signal("client_connection_failed")
	
	return netErr

func _on_client_disconnected(id = 1):
	if multiplayer.is_server():
		_disconnect_peers.rpc()
		await server_closing_peers_disconnected
		close_server()
	else:
		multiplayer.multiplayer_peer = null
		emit_signal("client_disconnected")
	

@rpc("authority", "call_remote")
func _disconnect_peers():
	%Lobby.visible = false
	%MainMenu.visible = true
	multiplayer.multiplayer_peer = null
	server_closing_peers_disconnected.emit
	
