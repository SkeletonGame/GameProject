extends AnimatedSprite

func _process(delta):
	bar_move()

var pos = 0
func bar_move():
	if Input.is_action_just_pressed("down") and pos < 3:
		pos += 1
		get_parent().move_and_slide(Vector2(0, 11500))
	if Input.is_action_just_pressed("up") and pos > 0:
		pos -= 1
		get_parent().move_and_slide(Vector2(0, -11500))
