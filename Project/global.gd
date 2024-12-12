extends Node



func _ready() -> void:
	pass
	

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
