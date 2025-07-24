extends Sprite2D

var x_max = [-1,1]
var r_max = [-3,3]
var pivot_below = true
var start_x = 0
var start_r = 0
const STOP_THRESHOLD = .1
const TWEEN_DURATION = .02
const RECOVERY_FACTOR = 2.0/3
const TRANSITION_TYPE = Tween.TRANS_SINE

signal tween_completed

func _ready():
	start_x = position.x
	start_r = rotation
# Called when the node enters the scene tree for the first time.
func start():
	
	var x = x_max[randi_range(0,1)]
	var r = r_max[randi_range(0,1)]
	while abs(x) > STOP_THRESHOLD:
		
		var tween = _tilt_left(x, r)
		await tween.finished
		x *= RECOVERY_FACTOR
		r *= RECOVERY_FACTOR
		
		_recenter()
		
		tween = _tilt_right(x, r)
		await tween.finished

		x *= RECOVERY_FACTOR
		r *= RECOVERY_FACTOR
		
		_recenter()
		
	emit_signal("tween_completed")

func _tilt_left(x, r) -> Tween:
	var tween = create_tween().set_parallel()
	
	tween.tween_property(self, "position:x", (start_x-x), TWEEN_DURATION).set_trans(TRANSITION_TYPE).set_ease(Tween.EASE_OUT)
	r = -r if pivot_below else r
	tween.tween_property(self, "rotation_degrees", (start_r+r), TWEEN_DURATION).set_trans(TRANSITION_TYPE).set_ease(Tween.EASE_OUT)
	
	return tween
	
func _tilt_right(x, r) -> Tween:
	var tween = create_tween().set_parallel()
	
	tween.tween_property(self, "position:x", (start_x+x), TWEEN_DURATION).set_trans(TRANSITION_TYPE).set_ease(Tween.EASE_OUT)
	r = r if pivot_below else -r
	tween.tween_property(self, "rotation_degrees", (start_r+r), TWEEN_DURATION).set_trans(TRANSITION_TYPE).set_ease(Tween.EASE_OUT)
	
	return tween
	
func _recenter():
	var tween = create_tween().set_parallel()
	
	tween.tween_property(self, "position:x", start_x, TWEEN_DURATION).set_trans(TRANSITION_TYPE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation_degrees", start_r, TWEEN_DURATION).set_trans(TRANSITION_TYPE).set_ease(Tween.EASE_IN)
	
	return tween
