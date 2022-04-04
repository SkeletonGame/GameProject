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
var speed_of_other_boat = Vector2(0, 0)
var weight = 6
func _on_Area2D_body_entered(body: Node) -> void:
	if timer > 0.5:
		collision = true
		speed_of_other_boat = get_parent().get_node(body.name).speed
func _on_Area2D_body_exited(body: Node) -> void:
	if timer > 0.5:
		collision = false
func collision_handler(delta):
	timer += delta
	if collision:
		speed += speed_of_other_boat * (1.1 - (weight / 10))

var AI = false
var RNG = RandomNumberGenerator.new()
var target = ""
var target_info = {}
var playersstillonboard = []
var result
var AI_intent = ""
var AI_go_decision = false
var impending_doom = false
func _on_AI_Cliff_Sensor_area_exited(area: Area2D) -> void:
	impending_doom = true
func _on_AI_Cliff_Sensor_area_entered(area: Area2D) -> void:
	impending_doom = false
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
func AI_death_prevention():
	AI_go_decision = false
	AI_turning_decision = -1
func legitimately_skynet():
	target_handling()
	if impending_doom:
		AI_intent = "not dying"
		AI_death_prevention()
	else:
		AI_go_decision = true
		AI_turning_decision = 0

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

