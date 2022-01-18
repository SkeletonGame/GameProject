extends Node2D

func loadjson(filename):
	var file = File.new()
	file.open("datafiles/" + filename + ".json", file.READ)
	var data = {}
	var text = file.get_as_text()
	data = parse_json(text)
	file.close()
	return data

var room_v = ""
var room = ""
var limits_dict = {}
var room_limits = {}
func limitProcess():
	room = get_parent().get_parent().name
	if not room == room_v:
		limits_dict = loadjson("camera_limits")
		if room in limits_dict:
			room_limits = limits_dict[room]
			for i in ["limit_l", "limit_r", "limit_t", "limit_b"]:
				if not i in room_limits:
					room_limits[i] = 1000000000
					if i == "limit_l" or i == "limit_t":
						room_limits[i] = room_limits[i] * -1
		else:
			for i in ["limit_l", "limit_r", "limit_t", "limit_b"]:
				room_limits[i] = 1000000000
				if i == "limit_l" or i == "limit_t":
					room_limits[i] = room_limits[i] * -1
		get_parent().get_node("KinematicMatt").get_node("Camera2D").limit_left = room_limits["limit_l"]
		get_parent().get_node("KinematicMatt").get_node("Camera2D").limit_right = room_limits["limit_r"]
		get_parent().get_node("KinematicMatt").get_node("Camera2D").limit_top = room_limits["limit_t"]
		get_parent().get_node("KinematicMatt").get_node("Camera2D").limit_bottom = room_limits["limit_b"]
		room_v = room

var object = ""
var c1 = false
var c2 = false
var c3 = false # conditions 1, 2, and 3
var object_x
var object_y # getting the object's position
var matt_x
var matt_y
var cam_x = 0
var cam_y = -0.02 # default camera position
func camera_move():
	object = ""
	c1 = get_parent().get_node("KinematicMatt").motion_lock
	c2 = get_parent().get_node("AreaMatt").person != ""
	c3 = get_parent().get_node("AreaMatt").speech_type == "dialogue"
	if c1 and c2 and c3:
		object = get_parent().get_node("AreaMatt").person
	c2 = get_parent().get_node("AreaMatt").interactable != ""
	c3 = get_parent().get_node("AreaMatt").speech_type == "interaction"
	if c1 and c2 and c3:
		object = get_parent().get_node("AreaMatt").interactable
	if object != "":
		object_x = get_parent().get_parent().get_node(object).get_position()[0]
		object_y = get_parent().get_parent().get_node(object).get_position()[1]
		matt_x = get_parent().get_node("KinematicMatt").get_position()[0]
		matt_y = get_parent().get_node("KinematicMatt").get_position()[1]
		get_parent().get_node("KinematicMatt").get_node("Camera2D").offset_h = cam_x - (matt_x - object_x) / 500
		get_parent().get_node("KinematicMatt").get_node("Camera2D").offset_v = cam_y - (matt_y - object_y) / 1000 + 0.3
	else:
		get_parent().get_node("KinematicMatt").get_node("Camera2D").offset_h = cam_x
		get_parent().get_node("KinematicMatt").get_node("Camera2D").offset_v = cam_y

var current = ""
var new = "x1"
var current_num = 1.26
var new_num = 1.26
var zoom_speed = 40
var counter = 0
var camera_zooms = {
	"x1": 1.26,
	"x0.5": 2.12
}
var internalZoom = [current_num, current_num]
func zoom_change(delta):
	if new == current:
		current_num = camera_zooms[current]
		counter = 0
	elif new != current:
		counter += delta
		if new_num != camera_zooms[new]:
			new_num = camera_zooms[new]
		current_num += (new_num - current_num) / (zoom_speed - counter)
		if current_num + 0.1 > new_num and current_num - 0.1 < new_num: # guesstimate
			current = new
		internalZoom = [current_num, current_num]

func aspect_ratio_dealwither():
	get_parent().get_node("KinematicMatt").get_node("Camera2D").zoom.x = internalZoom[0] * (1920 / get_viewport_rect().size[0])
	get_parent().get_node("KinematicMatt").get_node("Camera2D").zoom.y = internalZoom[1] * (1080 / get_viewport_rect().size[1])

func _process(delta: float) -> void:
	limitProcess()
	camera_move()
	zoom_change(delta)
	aspect_ratio_dealwither()
