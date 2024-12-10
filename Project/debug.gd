extends Control

@onready var connected_peers: Label = $"VBoxContainer/Connected Peers"
@onready var pid: Label = $VBoxContainer/PID
@onready var client_id: Label = $VBoxContainer/Client_ID
@onready var command: LineEdit = $VBoxContainer/command


func run(method : StringName):
	var methods : Dictionary = {
		"update_connected_peers": func ():
				var network: NetworkHandler = %Network
				connected_peers.text = "Connected Peers: " + str(network.players_connected)
				,
		"update_pid": func ():
				pid.text = "PID: " + str(OS.get_process_id())
				,
		"update_clientID": func ():
				if multiplayer.multiplayer_peer:
					client_id.text = str( multiplayer.get_unique_id() )
	}
	
	if method in methods.keys():
		methods[method].call()
	else:
		printerr("Debug method does not exist.")
		return


func _ready() -> void:
	run("update_pid")

func _process(delta: float) -> void:
	run("update_connected_peers")
	run("update_clientID")



func _on_command_text_submitted(_new_text: String) -> void:
	$debug/VBoxContainer/command.placeholder_text = "cmd currently unavailable"
	$debug/VBoxContainer/command.deselect()
	$debug/VBoxContainer/command.clear()
	$debug/VBoxContainer/command.release_focus()
