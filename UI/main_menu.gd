extends Control

@onready var network: Node = %Network

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
	
func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_host_pressed() -> void:
	if network.create_server() == OK:
		self.visible = false
		%Lobby.visible = true
	
func _on_join_pressed() -> void:
	if network.create_client() == OK:
		self.visible = false
		%Lobby.visible = true
