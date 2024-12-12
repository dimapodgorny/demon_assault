extends Control

@onready var connected_peers: Label = $"VBoxContainer/Connected Peers"
@onready var pid: Label = $VBoxContainer/PID
@onready var client_id: Label = $VBoxContainer/Client_ID
@onready var physics_process_delta: Label = $"VBoxContainer/Physics Process Delta"
@onready var process_delta: Label = $"VBoxContainer/Process Delta"

@onready var command: LineEdit = $VBoxContainer/command
@onready var network: NetworkHandler = %Network

func readyUpdate() -> void:
	var methods : Dictionary = {
		"pid": func ():
			pid.text = "PID: " + str(OS.get_process_id())
	}
	
	for method in methods.keys():
		methods[method].call()

func AlwaysUpdate():
	var methods : Dictionary = {
		"connected_peers": func ():
				connected_peers.text = "Connected Peers: " + str(network.players_connected)
				,
		"clientID": func ():
				if network.networkPeer:
					client_id.text = str( multiplayer.get_unique_id() )
				,
		"physics_process_delta": func ():
				physics_process_delta.text = str("Physics delta: ", get_physics_process_delta_time() )
				,
		"process_delta": func ():
				process_delta.text = str("Process delta: ", get_process_delta_time() )
				,
	}
	get_tree()
	for method in methods.keys():
		methods[method].call()
	

func _ready() -> void:
	readyUpdate()

func _process(_delta: float) -> void:
	AlwaysUpdate()



func _on_command_text_submitted(_new_text: String) -> void:
	$debug/VBoxContainer/command.placeholder_text = "cmd currently unavailable"
	$debug/VBoxContainer/command.deselect()
	$debug/VBoxContainer/command.clear()
	$debug/VBoxContainer/command.release_focus()
