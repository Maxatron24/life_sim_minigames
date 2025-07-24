extends CanvasLayer

@onready var option_button: OptionButton = $OptionButton
@onready var button: Button = $Button
@onready var game: Control = %Game




func _on_button_pressed() -> void:
	var axe_tier = option_button.selected
	print(axe_tier)
	game._setup_game(axe_tier)
	self.visible = false
