extends Control
class_name PlayerSlot

@export var PlayerName : String
@export var PlayerIcon : CompressedTexture2D 

func _ready() -> void:
	if PlayerIcon == null: PlayerIcon = load("res://TEXTURE_NULL.tres")
	$PlayerIcon.texture = PlayerIcon
	if PlayerName == null: PlayerName = "null"
	$PlayerName.text = str(PlayerName)
	
	


func _on_challenge_button_pressed() -> void:
	var UniqueID = multiplayer.get_unique_id()
	ChallengeHandler.received.rpc_id(self.name.to_int(), UniqueID, self.name.to_int())
	
	print(OS.get_process_id(),":\n", multiplayer.get_unique_id(), " (self) is challenging ", self.name)
	
	$"../../../../ChallengePrompter".visible = true
	$"../../../../ChallengePrompter/Challenging Player".visible = true
