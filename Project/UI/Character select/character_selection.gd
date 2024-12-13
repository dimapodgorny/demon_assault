extends Control

@onready var character_icon: TextureRect = $"control/Character Icon"
var character_button: Button

func _ready() -> void:	
	if owner is Main:
		visible = false
		$ColorRect.visible = true
	
	for character_key in Global.char_paths:
		var character := Fighter.new()
		character = load(Global.char_paths[character_key]).instantiate()
		character_icon.texture = character.player_portrait.duplicate()
		
		var charBtn := Control.new()
		charBtn = load("res://UI/character_slot.tscn").instantiate()
		$control/ScrollContainer/VBoxContainer.call_deferred("add_child", charBtn)
		
		character.call_deferred("queue_free")
		
