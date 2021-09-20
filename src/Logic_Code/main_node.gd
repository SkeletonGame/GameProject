extends Maus

func _ready():
	OS.window_fullscreen = 1

func loadfile():
	var file = File.new()
	file.open("save.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	return content

var GDict = {}
func _process(delta):
	GDict['mx'] = mx
	GDict['my'] = my
	GDict['m1'] = m1
	GDict['m2'] = m2
	GDict['m1_t'] = m1_t
	GDict['m2_t'] = m2_t
	if Input.is_action_just_pressed("escape"):
		OS.window_fullscreen = 1 - 1 #int(OS.window_fullscreen)


func _on_badingus_body_entered(body: Node) -> void:
	print(body)
	print("lmao ahaha 435")
	print("lmao ahaha 425")
