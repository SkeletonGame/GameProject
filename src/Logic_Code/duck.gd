extends AnimatedSprite

var RNG = RandomNumberGenerator.new()
var pick = 0
var table_pos = Vector2(0, 0)
var local_y = 0
# this function will pick a color for the duck, and theres a 1/5 chance that it is green instead of yellow
# it also assigns it a position with a randomized y position. It is dependent on being inside of the nodes of the Garage scene, 
# so this duck scene will not work without being inside the right place
func _ready() -> void:
	animation = "default"
	RNG.randomize()
	pick = RNG.randi_range(0, 4)
	if pick == 4:
		animation = "green"
	table_pos = get_parent().get_parent().position
	RNG.randomize()
	pick = RNG.randf_range(0, 200) # 200 is a bit smaller than the height of the TV
	local_y = 100 - pick # local_y is important for targeting- dont ask why im subtracting it from 100 its so the zero is angle zero please dont do the math trust me
	position = table_pos
	position.x -= 400
	position.y -= 300 # this moves it from the center of the TV to the topleft
	position.y += pick

var acc = 50
var speed = 0
# this function is very straightforward, it simply moves the duck out onto the screen with a delta-based speed
# it also makes the green ducks move faster, since theyre supposed to be like the bonus ones or whatever
func entrance(delta):
	if not position.x > table_pos.x - 250:
		if acc > 0.0001:
			if animation == "green":
				acc -= 60 * delta
			else:
				acc -= 180 * delta
		else:
			acc += 0.1
		speed += acc
		position.x += speed * delta
	elif position.x > table_pos.x - 250:
		mode = "stay"

func stay():
	if not get_parent().name in get_parent().get_parent().targets:
		get_parent().get_parent().targets.append(get_parent().name)

var explode_init = false
func explode():
	if not explode_init:
		scale = Vector2(2.4, 1.3)
		RNG.randomize()
		position.x += RNG.randf_range(0, 60)
		z_index += 1
		explode_init = true
		get_node("BOOM").play()
	animation = "explosion"

func _on_duck_animation_finished() -> void:
	if animation == "explosion":
		visible = false

func _on_BOOM_finished() -> void:
	queue_free()

var mode = "enter"
func _process(delta: float) -> void:
	if mode == "enter":
		entrance(delta)
	elif mode == "stay":
		stay()
	elif mode == "dead":
		explode()




