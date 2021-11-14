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
func _process(delta: float) -> void:
	limitProcess()
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
		if abs((matt_x - object_x) / 400) > 0.2:
			get_parent().get_node("KinematicMatt").get_node("Camera2D").offset_h = cam_x - (matt_x - object_x) / 400
		if abs((matt_y - object_y - 200) / 400) > 0.2:
			get_parent().get_node("KinematicMatt").get_node("Camera2D").offset_v = cam_y - (matt_y - object_y - 200) / 400
	else:
		get_parent().get_node("KinematicMatt").get_node("Camera2D").offset_h = cam_x
		get_parent().get_node("KinematicMatt").get_node("Camera2D").offset_v = cam_y
