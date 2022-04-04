extends KinematicBody2D

var perks = []
var player_color = "Red"
func _ready() -> void:
	get_node("Boat").animation = "idle"

var acceleration_turning = 2.9
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

var speed = Vector2(0, 0)
var acceleration_forward = 20
var drift = 12
var top_speed = 900
func speed_handling():
	move_and_slide(speed)
	if Input.is_action_pressed("w") and color == player_color:
		speed[0] += (cos(rotation_degrees / 360 * 2 * PI)) * acceleration_forward
		speed[1] += (sin(rotation_degrees / 360 * 2 * PI)) * acceleration_forward
	if AI and AI_go_decision:
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
var weight = 4
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
		speed -= (other_boat.global_position - position) * other_boat.weight
		if AI:
			target = other_boat.name

var AI = false
var RNG = RandomNumberGenerator.new()
var target = ""
var target_info = {}
var playersstillonboard = []
var result
var AI_intent = ""
var possible_intents = ["spin", "go", "chase"]
var AI_timer = 0
var AI_arbitrary_value = 0
var AI_go_decision = false
var impending_doom = false
var dead_ahead_inside_arena = true
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
func target_handling():
	playersstillonboard = []
	for this in get_parent().get_children():
		if this.name in colors:
			playersstillonboard.append(this.name)
	if not target in playersstillonboard and playersstillonboard.size() > 0:
		RNG.randomize()
		target = playersstillonboard[RNG.randi_range(0, playersstillonboard.size() - 1)]
func AI_chase():
	target_info["angle_to"] = rad2deg(get_angle_to(get_parent().get_node(target).position))
	if target_info["angle_to"] > 10:
		AI_turning_decision = 1
	elif target_info["angle_to"] < -10:
		AI_turning_decision = -1
	else:
		AI_turning_decision = 0
	AI_go_decision = true
func AI_doom_detection():
	impending_doom = !bool(int(dead_ahead_inside_arena) * int(right_inside_arena) * int(left_inside_arena))
func AI_death_prevention():
	if dead_ahead_inside_arena:
		AI_go_decision = true
	else:
		AI_go_decision = false
	if not right_inside_arena:
		AI_turning_decision = -1
	else:
		AI_turning_decision = 1
func AI_free_will(): # unused, doesnt quite work
	print(AI_intent)
	if AI_intent == "":
		RNG.randomize()
		AI_intent = possible_intents[RNG.randi_range(0, possible_intents.size() - 1)]
	elif AI_intent == "spin":
		AI_go_decision = false
		if AI_turning_decision == 0:
			RNG.randomize()
			AI_turning_decision == [-1, 1][RNG.randi_range(0, 1)]
			RNG.randomize()
			AI_arbitrary_value = RNG.randi_range(40, 100)
			AI_timer = 0
		AI_timer += 1
		if AI_timer > AI_arbitrary_value:
			AI_intent = ""
	elif AI_intent == "chase":
		AI_chase()
	else:
		AI_go_decision = true
		AI_intent = ""

func legitimately_skynet():
	target_handling()
	AI_doom_detection()
	if impending_doom:
		AI_death_prevention()
	else:
		AI_chase()

var colors = {
	"Red": Color(1, 1, 1),
	"Green": Color(0.5, 1, 0.5),
	"Blue": Color(0.5, 0.5, 1),
	"Yellow": Color(0.75, 1, 0.25),
}
var color = ""
var cam_init = false
func _process(delta: float) -> void:
	if color in colors:
		get_node("Boat").modulate = colors[color]
		if color != player_color: AI = true # actually skynet
	if color == player_color and timer > 0.01 and not cam_init:
		get_node("Camera2D").current = false
		get_node("Camera2D").current = true
		cam_init = true
	turning_handling()
	speed_handling()
	dead_handling()
	collision_handler(delta)
	if AI and not dead:
		legitimately_skynet()
