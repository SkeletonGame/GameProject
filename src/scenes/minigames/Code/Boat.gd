extends KinematicBody2D

var perks = []
var player_color = "Red"
func _ready() -> void:
	get_node("Boat").animation = "idle"

var acceleration_turning = 2.6
var acceleration_turning_buffer = 0
var rotation_speed = 0.0
var friction = 10.0
var AI_turning_decision = 0
func turning_handling():
	if Input.is_action_pressed("right") and color == player_color:
		acceleration_turning_buffer += (acceleration_turning / 13)
	if Input.is_action_pressed("left") and color == player_color:
		acceleration_turning_buffer -= (acceleration_turning / 13)
	if AI:
		acceleration_turning_buffer += (acceleration_turning / 13) * AI_turning_decision
	rotation_speed += (acceleration_turning_buffer) / 10
	rotation_degrees += rotation_speed
	acceleration_turning_buffer *= 0.9
	rotation_speed *= 1 - friction/100

var AI_power_decision = false
var power = "boost"
var boosting = false
var power_timer_reset = 1200
var power_timer = power_timer_reset
func power_handling():
	power_timer += 1
	if ((Input.is_action_pressed("space") and color == player_color) or (AI and AI_power_decision)) and power_timer > power_timer_reset:
		power_timer = 0
		if power == "boost":
			boosting = true
			acceleration_forward += 70
			weight += 0.5
			acceleration_turning -= 0.8
	if boosting:
		speed[0] += (cos(rotation_degrees / 360 * 2 * PI)) * acceleration_forward
		speed[1] += (sin(rotation_degrees / 360 * 2 * PI)) * acceleration_forward
	if boosting and power_timer > power_timer_reset / 3:
		boosting = false
		acceleration_forward -= 70
		weight -= 0.5
		acceleration_turning += 0.8

var speed = Vector2(0, 0)
var acceleration_forward = 25
var drift = 11
var top_speed = 1200
func speed_handling():
	move_and_slide(speed)
	if (Input.is_action_pressed("w") and color == player_color) or (AI and AI_go_decision) and not dead:
		speed[0] += (cos(rotation_degrees / 360 * 2 * PI)) * acceleration_forward
		speed[1] += (sin(rotation_degrees / 360 * 2 * PI)) * acceleration_forward
	speed[0] *= 1 - friction/(drift * 90)
	speed[1] *= 1 - friction/(drift * 90)
	if abs(speed[0]) > top_speed:
		speed[0] = (top_speed + (abs(speed[0]) - top_speed) / 3) * (speed[0] / abs(speed[0]))
	if abs(speed[1]) > top_speed:
		speed[1] = (top_speed + (abs(speed[1]) - top_speed) / 3) * (speed[1] / abs(speed[1]))

var dead = false
var fell = false
var boats = []
func _on_Boat_animation_finished() -> void:
	if get_node("Boat").animation == "falling":
		fell = true
func dead_handling():
	if dead:
		get_node("Boat").animation = "falling"
	if fell:
		get_parent().remove_child(get_parent().get_node(name))

var timer = 0.0
var collision = false
var other_boat = ""
var weight = 0.4
var bounce_vector = Vector2(0, 0)
func _on_Area2D_body_entered(body: Node) -> void:
	if timer > 0.5:
		collision = true
		other_boat = get_parent().get_node(body.name)
func _on_Area2D_body_exited(body: Node) -> void:
	if timer > 0.5:
		collision = false
func collision_handler(delta):
	timer += delta
	if collision:
		bounce_vector = (other_boat.global_position - position) * other_boat.weight
		speed -= bounce_vector * 5
		if AI:
			target = other_boat.name
	speed -= bounce_vector
	bounce_vector[0] *= 0.8
	bounce_vector[1] *= 0.8

var AI = false
var RNG = RandomNumberGenerator.new()
var target = ""
var target_info = {}
var playersstillonboard = []
var result
var AI_timer = 0
var AI_go_decision = false
var impending_doom = false
var backstab_doom = false
var dead_ahead_inside_arena = true
var chase_failed = false
var right_inside_arena = true
var left_inside_arena = true
func _on_Dead_Ahead_Sensor_area_entered(area: Area2D) -> void:
	dead_ahead_inside_arena = true
func _on_Dead_Ahead_Sensor_area_exited(area: Area2D) -> void:
	dead_ahead_inside_arena = false
func _on_Right_Sensor_area_entered(area: Area2D) -> void:
	right_inside_arena = true
func _on_Right_Sensor_area_exited(area: Area2D) -> void:
	right_inside_arena = false
func _on_Left_Sensor_area_entered(area: Area2D) -> void:
	left_inside_arena = true
func _on_Left_Sensor_area_exited(area: Area2D) -> void:
	left_inside_arena = false
func _on_Back_Sensor_area_entered(area: Area2D) -> void:
	backstab_doom = false
func _on_Back_Sensor_area_exited(area: Area2D) -> void:
	backstab_doom = true
func target_choosing():
	playersstillonboard = []
	result = ""
	for this in get_parent().get_children():
		if this.name in colors:
			playersstillonboard.append(this.name)
	if not target in playersstillonboard and playersstillonboard.size() > 0:
		RNG.randomize()
		target = playersstillonboard[RNG.randi_range(0, playersstillonboard.size() - 1)]
	return result
func AI_chase():
	playersstillonboard = []
	for this in get_parent().get_children():
		if this.name in colors:
			playersstillonboard.append(this.name)
	if target in playersstillonboard:
		target_info["angle_to"] = rad2deg(get_angle_to(get_parent().get_node(target).position))
		if target_info["angle_to"] > 10:
			AI_turning_decision = 1
		elif target_info["angle_to"] < -10:
			AI_turning_decision = -1
		else:
			AI_turning_decision = 0
		AI_go_decision = abs(target_info["angle_to"]) < 20
		if power == "boost" or power == "shoot":
			AI_power_decision = AI_go_decision
	else:
		target = ""
	if AI_timer > 1000:
		AI_timer = 0
		target = ""
func AI_doom_detection():
	impending_doom = !bool(int(dead_ahead_inside_arena) * int(right_inside_arena) * int(left_inside_arena))
func AI_death_prevention():
	AI_go_decision = false
	if not right_inside_arena:
		AI_turning_decision = -1
	else:
		AI_turning_decision = 1
func AI_freewheeling():
	if AI_timer & 100 == 0:
		RNG.randomize()
		AI_turning_decision = RNG.randi_range(-1, 1)
		RNG.randomize()
		AI_go_decision = bool(RNG.randi_range(0, 1))
	if AI_timer > 500:
		AI_timer = 0
		playersstillonboard = []
		for this in get_parent().get_children():
			if this.name in colors:
				playersstillonboard.append(this.name)
		target = playersstillonboard[0]
func legitimately_skynet():
	AI_doom_detection()
	AI_power_decision = false
	AI_timer += 1
	if impending_doom:
		AI_death_prevention()
	elif backstab_doom:
		AI_turning_decision = 0
		AI_go_decision = true
		if power == "boost":
			AI_power_decision = true
	elif target != "":
		AI_chase()
	else:
		AI_freewheeling()

var colors = {
	"Red": Color(1, 1, 1),
	"Green": Color(0.5, 1, 0.5),
	"Blue": Color(0.5, 0.5, 1),
	"Yellow": Color(0.75, 1, 0.25),
}
var color = ""
func _process(delta: float) -> void:
	if color in colors:
		get_node("Boat").modulate = colors[color]
		if color != player_color: AI = true # actually skynet
	power_handling()
	turning_handling()
	speed_handling()
	dead_handling()
	collision_handler(delta)
	if AI and not dead:
		legitimately_skynet()
