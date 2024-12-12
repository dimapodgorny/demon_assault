extends Node

signal challenged
signal accepted
signal declined

var Player_Challenging

func _ready() -> void:
	#challenged.connect()
	accepted.connect(on_accepted)
	declined.connect(on_declined)
	

@rpc("any_peer", "call_local", "reliable")
func received(player_challenging : int, challenged_player : int):
	Player_Challenging = player_challenging
	print(OS.get_process_id(), ":\n", player_challenging, " has challenged ", challenged_player)
	challenged.emit()

@rpc("any_peer", "call_local", "reliable")
func on_accepted():
	print_debug("Challenge accepted!")
	
@rpc("any_peer", "call_local", "reliable")
func on_declined():
	print_debug("Challenge declined!")
	
