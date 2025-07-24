extends TextureProgressBar

var max_value_amount = 100
var min_value_amount = 0
var current_health = 50
var catch_difficulty = 20
var bad_strength: float = 5
var good_strength: float = 1.5
var shake_fade: float = 5.0
var shake_strength: float = 0.0
var rng = RandomNumberGenerator.new()
var reel = false
var release = false
var reel_time = 0
var initial_reel_speed = 2
var release_speed = 3
var reel_rotation_midpoint = deg_to_rad(-35)
var reel_rotation_target = deg_to_rad(-20)
var release_rotation_target = deg_to_rad(-50)

func _set_health():
	max_value = max_value_amount
	current_health = max_value_amount/2
	value = current_health
	
func _shake(good):
	if good == true:
		var tween = create_tween()
		var x = position.x
		tween.tween_property(self, "position:x", x+4, .01)
		tween.tween_property(self, "position:x", x-4, .01)
		tween.tween_property(self, "position:x", x, .01)
	else:
		var tween = create_tween()
		var x = position.x
		tween.tween_property(self, "position:x", x+10, .015)
		tween.tween_property(self, "position:x", x-10, .015)
		tween.tween_property(self, "position:x", x, .015)
	
	
func _release():
	var tween = create_tween()
	tween.tween_property(self, "rotation",release_rotation_target,.5).set_ease(Tween.EASE_IN)
	
func _reel():
	var tween = create_tween()
	tween.tween_property(self, "rotation",reel_rotation_midpoint,1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation",reel_rotation_target,1.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
