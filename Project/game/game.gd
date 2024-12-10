extends Node2D
class_name Game

@export var game_size := Vector2(600, 400)
@export var border_width : float = 5.0
@export var border_color := Color("#FFFFFF")
var border_BL = Vector2(-(game_size.x/2), (0+border_width))
var border_BR = Vector2(game_size.x/2, (0+border_width))
var border_TL = Vector2(-(game_size.x/2), -(game_size.y+border_width))
var border_TR = Vector2(game_size.x/2, -(game_size.y+border_width))

@onready var game_cam: GameCamera = $GameCam




func spawn_players() -> void:
	pass



	
func _get_players():
	var playerCharPath = Global.playerCharPath
	var playerNode = load(playerCharPath).instantiate()
	$Players.add_child(playerNode)
