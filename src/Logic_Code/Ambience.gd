extends AudioStreamPlayer

var current = ""
var noises = {}
var dir = Directory.new()

func _ready():
	dir.open("res://noises/ambience/")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".wav"):
			noises[file] = load("res://noises/ambience/" + file)
	dir.list_dir_end()

# Current is accessed and changed by the scene, not by this code
func _process(delta: float) -> void:
	if current in noises and not playing:
		stream = noises[current]
		play()
	elif not current in noises:
		stop()
