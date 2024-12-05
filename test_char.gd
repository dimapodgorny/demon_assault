extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down") )
	
	if is_multiplayer_authority():
		if direction:
			position += (direction*SPEED)*delta
	
	move_and_slide()
