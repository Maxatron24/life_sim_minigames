extends Control

var target = preload("res://scenes/click_spot.tscn")
var score = 0.0
var can_start = false
var game_running = false
var axe_modifier = [.5,.75]
var axe_tier_array = [1,2,4,7,9]
var axe_tier = 1
var spawn_time = .73
var total_time = 8
var possible_score = 0
var wait_timer_time = 0

signal game_over

@onready var spawn_timer: Timer = $SpawnTimer
@onready var target_area: ReferenceRect = $TargetArea
@onready var overall_timer: Timer = $OverallTimer
@onready var overall_timer_label: Label = $OverallTimerLabel
@onready var instructions: Label = $Instructions
@onready var final_score: Label = $FinalScore
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var wait_timer_label: Label = $WaitTimerLabel
@onready var wait_timer: Timer = $WaitTimer

func _ready() -> void:
	overall_timer_label.visible = false
	final_score.visible = false
	sprite_2d.visible = false

func _process(delta: float) -> void:
	overall_timer_label.text = str(snapped(overall_timer.time_left,.1))
	wait_timer_label.text = str(snapped(wait_timer.time_left,1))
	if Input.is_action_just_pressed("left_click") && can_start:
		can_start = false
		_start_game()
		
func _setup_game(selection):
	if selection > 0:
		total_time = 7.0
	axe_tier = axe_tier_array[selection]
	spawn_time -= (0.1 * selection)
	can_start = true
	visible = true
	instructions.visible = true
	
func _start_game():
	game_running = true
	self.visible = true
	sprite_2d.visible = true
	instructions.visible = false
	wait_timer_label.visible = true
	label.visible = true
	wait_timer.start()
	
func _end_game():
	game_running = false
	overall_timer_label.visible = false
	spawn_timer.stop()
	final_score.text = "You Collected " + str(snapped(score,1)) + " Wood \n Out of " + str(snapped(possible_score,1))
	final_score.visible = true
	await get_tree().create_timer(2).timeout
	game_over.emit()
	
func _get_position():
	var area = target_area
	var new_position = area.position + Vector2(randf() * area.size.x, randf() * area.size.y)
	_spawn_target(new_position)
	possible_score += (0.5 + (axe_modifier[0] * axe_tier))
	
func _spawn_target(new_position):
	var instance = target.instantiate()
	instance.position = new_position
	add_child(instance)
	
func _add_score():
	score += (1 + (axe_modifier[0] * (axe_tier - 1)))

func _start_spawn_timer(location):
	spawn_timer.start(spawn_time)

func _on_spawn_timer_timeout() -> void:
	if overall_timer.time_left >= 0.25:
		_get_position()


func _on_child_exiting_tree(node: Node) -> void:
	if game_running:
		_add_score()
		sprite_2d.start()


func _on_overall_timer_timeout() -> void:
	_end_game()


func _on_wait_timer_timeout() -> void:
	wait_timer_label.visible = false
	label.visible = false
	spawn_timer.start(spawn_time)
	overall_timer.start(total_time)
	overall_timer_label.visible = true
