extends AnimatedSprite

func _process(delta: float) -> void:
	if Input.action_press("right"):
		position.x -= 10
	if Input.action_press("left"):
		position.x += 10
