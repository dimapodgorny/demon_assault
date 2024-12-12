extends Camera2D

signal position_changed

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event == InputEventKey && KEY_LEFT:
			position.x += 1

func _process(delta: float) -> void:
	var horizontalMove = Input.get_axis("left", "right")
	if horizontalMove:
		position_changed.emit()
		position.x += 1 * horizontalMove
	else:
		global_position = Vector2(0, 0)
		position_changed.emit()
