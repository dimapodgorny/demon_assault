extends Control
class_name CharacterSlot

@export var Name : String
@export var Icon : CompressedTexture2D

@onready var character_name: Label = $"character name"
@onready var character_icon: TextureRect = $"character icon"
@onready var selection: Button = $selection

@onready var character_selection: Control = $"../../../../"

func _ready() -> void:
	character_selection.character_button = selection
	if Name == null:
		Name = "n/a"
	if Icon == null:
		Icon = load("res://TEXTURE_NULL.png")
		
	character_name.text = Name
	character_icon.texture = Icon
	
	
