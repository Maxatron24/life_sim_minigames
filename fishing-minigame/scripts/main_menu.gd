extends Control


const FISHING = preload("res://scenes/fishing.tscn")
const CHOPPING_GAME = preload("res://scenes/chopping_game.tscn")
const HARVEST_GAME = preload("res://scenes/harvest_game.tscn")
const BUILDING_GAME = preload("res://scenes/building_game.tscn")
const COOKING_GAME = preload("res://scenes/cooking_game.tscn")

@onready var buttons: CanvasLayer = $Buttons

func _invisible():
	buttons.visible = false
	
func _visible():
	buttons.visible = true

func _on_start_fishing_button_pressed() -> void:
	var instance = FISHING.instantiate()
	add_child(instance)
	_invisible()

func _on_start_chopping_button_pressed() -> void:
	var instance = CHOPPING_GAME.instantiate()
	add_child(instance)
	_invisible()

func _on_start_harvest_button_pressed() -> void:
	var instance = HARVEST_GAME.instantiate()
	add_child(instance)
	_invisible()
	
func _on_start_building_button_pressed() -> void:
	var instance = BUILDING_GAME.instantiate()
	add_child(instance)
	_invisible()

func _on_start_cooking_button_pressed() -> void:
	var instance = COOKING_GAME.instantiate()
	add_child(instance)
	_invisible()

func _on_child_exiting_tree(node: Node) -> void:
	_visible()
