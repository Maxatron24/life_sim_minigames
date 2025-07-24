extends Control

@onready var click_spot_sprite: TextureRect = $ClickSpotSprite

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		queue_free()
