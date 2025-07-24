extends Node

@onready var fish_health: TextureProgressBar = $"../FishHealth"

var x_max = 1.5
var y_max = 1.5
const STOP_THRESHOLD = 0.1
const TWEEN_DURATION = 0.05
const RECOVERY_FACTOR = 2.0/3
const TRANSITION_TYPE = Tween.TRANS_SINE

signal tween_completed
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func start():
	
	var x = x_max
	var y = y_max
	while x > STOP_THRESHOLD:
		
		var tween = _move_left(x,y)
		await tween.tween_completed
		tween.queue_free()
		x *= RECOVERY_FACTOR
		y *=RECOVERY_FACTOR
		
		_recenter()
		
		tween = _move_right(x,y)
		await tween.tween_completed
		tween.queue_free()
		x *= RECOVERY_FACTOR
		y *= RECOVERY_FACTOR
		
		_recenter()
		
	emit_signal("tween_completed")
	
func _move_left(x, y) -> Tween:
	var tween = create_tween(
	
	
	tween.interpolate_property(
		fish_health, "position:x",
		0, -x,
		TWEEN_DURATION, TRANSITION_TYPE, Tween.EASE_OUT
	)
	
	tween.interpolate_property(
		fish_health, "position:y",
		0, -y,
		TWEEN_DURATION, TRANSITION_TYPE, Tween.EASE_OUT
	)
	
	tween.start()
	return tween
	
	
func _move_right(x, y) -> Tween:
	var tween = Tween.new()
	self.add_child(tween)
	
	tween.interpolate_property(
		fish_health, "position:x",
		0, x,
		TWEEN_DURATION, TRANSITION_TYPE, Tween.EASE_OUT
	)
	
	tween.interpolate_property(
		fish_health, "position:y",
		0, y,
		TWEEN_DURATION, TRANSITION_TYPE, Tween.EASE_OUT
	)
	
	tween.start()
	return tween

func _recenter():
	var tween = Tween.new()
	self.add_child(tween)
	
	
	var host_x = fish_health.position.x
	tween.interpolate_property(
		fish_health, "position:x",
		host_x, 0,
		TWEEN_DURATION, TRANSITION_TYPE, Tween.EASE_IN
	)
	
	var host_y = fish_health.position.y
	tween.interpolate_property(
		fish_health, "position:y",
		host_y, 0,
		TWEEN_DURATION, TRANSITION_TYPE, Tween.EASE_OUT
	)
	
	tween.start()
	return tween
