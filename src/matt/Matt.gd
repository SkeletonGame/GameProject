extends KinematicBody2D

var eye_mood = 'idle'
var animation = 'idle'
var direction = 'none'
func animation_handler():
	get_node("Eyes").set_animation(eye_mood)
	if direction == 'none':
		animation = "idle"
	elif direction == 'left':
		animation = "strut"
		get_node("AnimatedSprite").set_flip_h(false)
		get_node("Eyes").set_flip_h(false)
	elif direction == 'right':
		animation = "strut"
		get_node("AnimatedSprite").set_flip_h(true)
		get_node("Eyes").set_flip_h(true)
	get_node("AnimatedSprite").set_animation(animation)

var grav = 100.0
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
	if not jump_lock and Input.is_action_just_pressed("space") and ground_check and not Input.is_action_pressed("down"): # jump
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
		if not jump_lock and Input.is_action_pressed("space") and boonce < 3 and not Input.is_action_pressed("down"):
			boonce += 1
		if Input.is_action_pressed("down"):
			boonce -= 0.5
			if boonce < 0:
				boonce = 0
	if not jump_lock and Input.is_action_just_pressed("space") and ground_check and not Input.is_action_pressed("down"): # jump
		jump_looper = 11
		boonce = 2.5
		bounce_check = position.y
	if jump_looper:
		velocity.y -= (50 * jump_looper)
		jump_looper -= 1


var slope_type = "null" # assigns up or down to the two directions for a slope: A slope is either \ or /
var lateral = false # boolean that checks for lateral motion
var count = 0 # counting time with delta
var y_temp = 0 # temp y value
var jumping = false
func slope_phys(delta):
	velocity.x += Input.get_action_strength("right") * 7000 * delta
	velocity.x += Input.get_action_strength("left") * -7000 * delta
	velocity.x *= 0.88
	lateral = (Input.is_action_pressed("right") or Input.is_action_pressed("left"))
	if slope_type == "\\" and lateral:
		velocity.x -= 70
	if slope_type == "/" and lateral:
		velocity.x += 70
	if not lateral and not velocity.y < 0 and not jumping:
		velocity.y -= grav

var motion_lock = false

var jump_lock = false

func jumplck():
	jump_lock = true

var stage_directions = {}
var current_direction = {}
var up_arg = Vector2(0, 0)
func velocity_handler(delta):
	velocity = move_and_slide(velocity, up_arg, true)
	if get_slide_count() > 0 and surface != get_slide_collision(0).collider.name: ## detects if Matt is on a surface 
		surface = get_slide_collision(0).collider.name
		if surface[surface.length() - 1] == "!": #this exclamation point indicates a surface with special properties.
			if surface.substr(surface.length() - 7, 6) == "Bounce":
				boonce = 2
				bounce_check = position.y
				surface_property = "bounce"
			elif surface.substr(surface.length() - 7, 6) == "SlopeR":
				slope_type = "/"
				jumping = false
				surface_property = "slope"
			elif surface.substr(surface.length() - 7, 6) == "SlopeL":
				slope_type = "\\"
				jumping = false
				surface_property = "slope"
			else:
				print("Jonathan's Debug Notes:")
				slope_type = "null"
				print("Node " + surface + " has a special property that is not implemented or incorrectly written.")
		else:
			surface_property = "default"
	if get_parent().get_node("AreaMatt").stage_reset_flag == true:
		current_direction = {}
	if stage_directions.size() > 0:
		for direction in stage_directions:
			current_direction = {direction: stage_directions[direction]}
			break
		if "Matt_Move" in current_direction:
			if get_parent().position.x + position.x + 10 > current_direction["Matt_Move"] and get_parent().position.x + position.x - 10 < current_direction["Matt_Move"]:
				stage_directions.erase("Matt_Move")
			if get_parent().position.x + position.x < current_direction["Matt_Move"]:
				velocity.x += 7000 * delta
			elif get_parent().position.x + position.x > current_direction["Matt_Move"]:
				velocity.x += -7000 * delta
			velocity.x *= 0.88
		else:
			velocity.x *= 0
		if "Matt_Turn" in current_direction:
			if current_direction["Matt_Turn"] == "left":
				get_node("AnimatedSprite").set_flip_h(false)
				get_node("Eyes").set_flip_h(false)
			else:
				get_node("AnimatedSprite").set_flip_h(true)
				get_node("Eyes").set_flip_h(true)
			stage_directions.erase("Matt_Turn")
	elif !motion_lock: ## motion_lock stops motion
		if surface_property == "default":
			default_phys(delta)
		if surface_property == "bounce":
			bounce_phys(delta)
		if surface_property == "slope":
			slope_phys(delta)
	else:
		velocity.x *= 0.88
	ground_check()
	if velocity.x > 150:
		direction = "right"
	elif velocity.x < -150:
		direction = "left"
	else:
		direction = "none"
	velocity.y += grav
	mattPosition = position
	eye_mood = get_parent().get_node("AreaMatt").emotion

var mattPosition = position

func _physics_process(delta: float) -> void:
	animation_handler()
	velocity_handler(delta)
	touched_list_handler()

# This stuff down here is for AreaMatt

var touched = ""
var touched_list = []
var touched_remove = []
func _on_AreaMatt_body_entered(body: Node) -> void:
	touched_list.append(body)
	
	

func _on_AreaMatt_body_exited(body: Node) -> void:
	touched_remove.append(body)

func touched_list_handler():
	if touched_list.size() > 0:
		touched = touched_list[touched_list.size() - 1].name
		if touched_remove.size() > 0:
			touched_list.erase(touched_remove[0])
			touched_remove.erase(touched_remove[0])
	else:
		touched = ""


