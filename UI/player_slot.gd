extends Control
class_name PlayerSlot

@export var PlayerName : String
@export var PlayerIcon : CompressedTexture2D 

func _ready() -> void:
	if PlayerIcon == null: PlayerIcon = load("res://TEXTURE_NULL.tres")
	$PlayerIcon.texture = PlayerIcon
	if PlayerName == null: PlayerName = "null"
	$PlayerName.text = str(PlayerName)
	
	
	
