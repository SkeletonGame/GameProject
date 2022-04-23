extends AnimatedSprite

var RNG = RandomNumberGenerator.new()
var pick = 0
var table_pos = Vector2(0, 0)
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
	pick = RNG.randf_range(0, 0) # 200 is a bit smaller than the height of the TV
	position = table_pos
	position.x -= 400
	position.y -= 300 # this moves it from the center of the TV to the topleft
	position.y += pick

var acc = 55
var speed = 0
# this function is very straightforward, it simply moves the duck out onto the screen with a delta-based speed
# it also makes the green ducks move faster, since theyre supposed to be like the bonus ones or whatever
func entrance(delta):
	if not position.x > table_pos.x - 250:
		if acc > 0.0001:
			if animation == "green":
				acc -= 60 * delta
			else:
				acc -= 130 * delta
		else:
			acc += 0.1
		speed += acc
		position.x += speed * delta
	elif position.x > table_pos.x - 250:
		mode = "stay"

func stay():
	get_parent().get_parent().targets.append(get_parent().name)

var mode = "enter"
func _process(delta: float) -> void:
	if mode == "enter":
		entrance(delta)
	elif mode == "stay":
		stay()
