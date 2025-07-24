extends Control

signal game_over

func _end_game():
	game_over.emit()
