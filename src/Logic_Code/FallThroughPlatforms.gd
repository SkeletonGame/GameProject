extends CollisionShape2D

var count = 0
var wait = 0
func _process(delta: float) -> void:
	count += delta
	if Input.is_action_pressed("down") and Input.is_action_just_pressed("space"):
		disabled = true
		wait = count
	if disabled and count > wait + 0.04:
		disabled = false
