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
func _process(delta: float) -> void:
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
