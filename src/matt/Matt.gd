extends KinematicBody2D

var eye_mood = 'idle'
var animation = 'idle'
func animation_handler():
	if Input.is_action_just_pressed("right"):
		get_node("AnimatedSprite").set_flip_h(true)
		get_node("Eyes").set_flip_h(true)
		get_node("Eyes").set_visible(false)
		animation = 'strut'
	elif Input.is_action_just_pressed("left"):
		get_node("AnimatedSprite").set_flip_h(false)
		get_node("Eyes").set_flip_h(false)
		get_node("Eyes").set_visible(false)
		animation = 'strut'
	elif not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		get_node("Eyes").set_visible(true)
		animation = 'idle'
	get_node("Eyes").set_animation(eye_mood)
	get_node("AnimatedSprite").set_animation(animation)

var grav = 100.0
var innocous_variable;
var velocity = Vector2(0, 0)
var jump_looper = 0
var ground_check_var = 0
var ground_check = 0
var surface = ""
var surface_property = "default"
func ground_check():
	if position.y < ground_check_var + 0.0001 and position.y > ground_check_var - 0.0001:
		ground_check = 1
	else:
		ground_check = 0
	ground_check_var = position.y

func default_phys(delta):
	velocity.x += Input.get_action_strength("right") * 7000 * delta
	velocity.x += Input.get_action_strength("left") * -7000 * delta
	velocity.x *= 0.88
	if Input.is_action_just_pressed("space") and ground_check and not Input.is_action_pressed("down"): # jump
		jump_looper = 10
	if jump_looper:
		velocity.y -= (50 * jump_looper)
		jump_looper -= 1

var bounce_check = 0
var boonce = 0
func bounce_phys(delta):
	velocity.x += Input.get_action_strength("right") * 7000 * delta
	velocity.x += Input.get_action_strength("left") * -7000 * delta
	velocity.x *= 0.88
	if boonce and round(position.y) == round(bounce_check) and ground_check:  ##this works perfectly, launches you into space like any good mattress should
		velocity.y -= 800 * boonce
		boonce -= 0.5
		if Input.is_action_pressed("space") and boonce < 3 and not Input.is_action_pressed("down"):
			boonce += 1
		if Input.is_action_pressed("down"):
			boonce -= 0.5
			if boonce < 0:
				boonce = 0
	if Input.is_action_just_pressed("space") and ground_check and not Input.is_action_pressed("down"): # jump
		jump_looper = 11
		boonce = 2.5
		bounce_check = position.y
	if jump_looper:
		velocity.y -= (50 * jump_looper)
		jump_looper -= 1

func velocity_handler(delta):
	velocity = move_and_slide(velocity)
	if get_slide_count() > 0 and surface != get_slide_collision(0).collider.name:
		surface = get_slide_collision(0).collider.name
		if surface[surface.length() - 1] == "!": #this exclamation point indicates a surface with special properties.
			if surface.substr(surface.length() - 7, 6) == "Bounce":
				boonce = 2
				bounce_check = position.y
				surface_property = "bounce"
			else:
				print("Jonathan's Debug Notes:")
				print("Node " + surface + " has a special property that is not implemented or incorrectly written.")
		else:
			surface_property = "default"
	if surface_property == "default":
		default_phys(delta)
	if surface_property == "bounce":
		bounce_phys(delta)
	ground_check()
	velocity.y += grav
	mattPosition = position

var mattPosition = position

func _physics_process(delta: float) -> void:
	animation_handler()
	velocity_handler(delta)


func _on_AreaMatt_body_entered(body: Node) -> void:
	print(str(body.name)+" entered matts area")
