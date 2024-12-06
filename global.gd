extends Node
func _ready() -> void:
	pass

var _syncNode = MultiplayerSynchronizer.new()
func sync_globals():
	_syncNode.visibility_update_mode = MultiplayerSynchronizer.VISIBILITY_PROCESS_NONE

func nothing() -> String:
	return "nothing"

#####################################
## Character stuff
var char_paths = {
	## "[name]": "[path].tscn",
	#"Tall Guy": "res://Characters/tall_guy/TallGuy.tscn",
	'Base Character': "res://Characters/BaseChar.tscn",
}

## Player stuff
var player1CharPath : String = ""
var player2CharPath : String = ""

var songs = {
	##"[name]": "res://[path]/[file]",
}
