extends Node2D

var distance = 5
var tackle_rarity = 1
var bait_rarity = 1
var fish_rarity = 1
var rod_strength_array = [1,3,5]
var rod_strength = 1
var fish_start = false
var can_start = false
var rest = false
var auto_click = false
var rng = RandomNumberGenerator.new()
var river_fish_array = ["Perch", "Salmon", "Catfish"]
var lake_fish_array = ["Chub", "Walleye", "Sturgeon"]
var ocean_fish_array = ["Crab", "Tuna", "Shark"]
var fish_number = 0
var fish_active = ""
var destination_diff = Vector2(576,0)
var move = false
var rod_destination = Vector2(0,0)

const SPEED = 1200

signal game_over


@onready var fish_node = get_node("LevelLayer/" + river_fish_array[0])
@onready var fish_health: TextureProgressBar = $LevelLayer/InterfaceLayer/FishHealth
@onready var label: Label = $LevelLayer/InterfaceLayer/Label
@onready var clicks_per_second: Timer = $ClicksPerSecond
@onready var rest_timer: Timer = $RestTimer
@onready var reel_timer: Timer = $ReelTimer
@onready var counter: Label = $LevelLayer/InterfaceLayer/Counter
@onready var instructions: Label = $LevelLayer/InterfaceLayer/Instructions
@onready var start_timer: Timer = $StartTimer
@onready var overall_timer: Timer = $OverallTimer
@onready var overall: Label = $LevelLayer/InterfaceLayer/Overall
@onready var texture_rect: TextureRect = $"../TextureRect"


func _setup_game(rod,location,difficulty,auto_clicker):
	#PICK FISH AND SET THE METRE
	rod_strength = rod_strength_array[rod]
	auto_click = auto_clicker
	_pick_fish(location,difficulty)
	fish_health._set_health()
	can_start = true
	fish_rarity = distance/5 * tackle_rarity * bait_rarity
	label.visible = true
	rest = false
	rod_destination = fish_health.position + destination_diff

func _start_game():
	move = true
	label.visible = false
	fish_health.visible = true
	can_start = false
	instructions.text = "Wait!"
	instructions.visible = true
	
	await  get_tree().create_timer(1).timeout
	_start_start_timer()
	
	
# SELECTS RANDOM FISH AND SETS STATS	
func _pick_fish(location,difficulty):
	if location == 0:
		fish_node = get_node("LevelLayer/" + river_fish_array[difficulty])
	elif location == 1:
		fish_node = get_node("LevelLayer/" + lake_fish_array[difficulty])
	elif location == 2:
		fish_node = get_node("LevelLayer/" + ocean_fish_array[difficulty])
	fish_active = fish_node.fish_name
	print((fish_active))
	fish_health.max_value_amount = fish_node.health_max
	fish_health.value = fish_node.health_max / 2
	fish_health.catch_difficulty = fish_node.catch_difficulty

# ADDS HEALTH TO METRE ON LEFT MOUSE CLICK
func _add_health(divider):
	fish_health.value += rod_strength * divider

	if fish_health.value >= fish_health.max_value_amount:
		_fish_caught()

# SUBTRACTS HEALTH FROM METRE PER SECOND BASED ON FISH
func _subtract_health():
	fish_health.value -= fish_health.catch_difficulty
	if fish_health.value <= 0:
		_fish_escape()
		
func _fish_caught():
	instructions.modulate = Color(1,1,1,1)
	instructions.text = "Congratulations! \nYou caught a " + str(fish_active)
	_end_game()
	
func _fish_escape():
	instructions.modulate = Color(1,1,1,1)
	instructions.text = "Oh No! \nThe Fish Escaped"
	_end_game()

func _line_cut():
	instructions.modulate = Color(1,1,1,1)
	instructions.text = "You Cut Your Line \nAnd Let The Fish Go"
	_end_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter.text = str(1 + (snapped(start_timer.time_left, 1)))
	if move && fish_health.position.x < 0:
		fish_health.position.x += 1 * SPEED * delta
		instructions.position.x += 1 * SPEED * delta
		counter.position.x += 1 * SPEED * delta
		texture_rect.position.x += 1 * SPEED * delta
	
	if overall_timer.time_left >= 10 && can_start == false:
		overall.modulate = Color(1,1,1,1)
		overall.text = str(snapped(overall_timer.time_left, 1))
	elif overall_timer.time_left < 10 && can_start == false:
		overall.modulate = Color(1,0,0,1)
		overall.text = str(snapped(overall_timer.time_left, 0.1))
	if Input.is_action_just_pressed("left_click") && can_start == true:
		_start_game()
	if fish_start == true && auto_click == false:
		if rest == false:
			if Input.is_action_just_pressed("left_click"):
				_add_health(1)
				fish_health._shake(true)
		else:
			if Input.is_action_just_pressed("left_click"):
				_subtract_health()
				fish_health._shake(false)
	if fish_start == true:
		if Input.is_action_just_pressed("right_click"):
			_line_cut()
		
		

# TIMER FOR HOW OFTEN HEALTH METRE DEPELTS 
func _on_timer_timeout() -> void:
	if fish_start == true && rest == false:
		_subtract_health()
		
# TIMER FOR WAITING TO RESET GAME
func _end_game():
	fish_start = false
	can_start = false
	fish_health.visible = false
	overall.visible = false
	reel_timer.stop()
	rest_timer.stop()
	overall_timer.stop()
	await get_tree().create_timer(2).timeout
	game_over.emit()
	
# TIMER FOR AUTO CLICKER (4CPS)
func _on_clicks_per_second_timeout() -> void:
	if fish_start == true && auto_click == true && rest == false:
		_add_health(1)
	elif fish_start == true && rest == true:
		_add_health(.25)
		
# TIMER FOR THE AMOUNT OF REST TIME
func _start_rest_timer():
	rest_timer.start(randf_range(1.0,3.0))
	

func _on_rest_timer_timeout() -> void:
	rest = false
	instructions.text = "Reel!"
	
	_start_reel_timer()

# TIMER FOR THE AMOUNT OF TIME REELING
func _start_reel_timer():
	instructions.modulate = Color(0.486275, 0.988235, 0, 1)
	fish_health._reel()
	reel_timer.start(randf_range(2.5,6.5))
	
func _on_reel_timer_timeout() -> void:
	rest = true
	fish_start = false
	instructions.modulate = Color(1,0,0,1)
	instructions.text = "Relax!"
	fish_health._release()
	await get_tree().create_timer(.5).timeout
	fish_start = true
	_start_rest_timer()
	
func _start_start_timer():
	start_timer.start()
	await get_tree().create_timer(.1).timeout
	counter.visible = true

func _on_start_timer_timeout() -> void:
	move = false
	fish_start = true
	counter.visible = false
	overall.visible = true
	instructions.text = "Reel!"
	clicks_per_second.start()
	_start_overall_timer()
	_start_reel_timer()
	
	
func _start_overall_timer():
	overall_timer.start()

func _on_overall_timer_timeout() -> void:
	_fish_escape()
