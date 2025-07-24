extends CanvasLayer

@onready var check_button: CheckButton = $CheckButton
@onready var rod_button: OptionButton = $RodButton
@onready var location_button: OptionButton = $LocationButton
@onready var difficulty_button: OptionButton = $DifficultyButton
@onready var fishing: Node2D = %Fishing



func _on_start_button_pressed() -> void:
	var rod = rod_button.selected
	var location = location_button.selected
	var difficulty = difficulty_button.selected
	var auto_click = check_button.button_pressed
	print(auto_click)
	self.visible = false
	fishing._setup_game(rod,location,difficulty,auto_click)
