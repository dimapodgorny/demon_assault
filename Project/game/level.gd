extends Node2D

@onready var game: Game = $".."

@onready var border_color = game.border_color
@onready var border_width = game.border_width
@onready var border_BL = game.border_BL
@onready var border_BR = game.border_BR
@onready var border_TL = game.border_TL
@onready var border_TR = game.border_TR

func _draw() -> void:
	draw_line(border_BL, border_BR, border_color, border_width)
	draw_line(border_BR, border_TR, border_color, border_width)
	draw_line(border_TR, border_TL, border_color, border_width)
	draw_line(border_TL, border_BL, border_color, border_width)
