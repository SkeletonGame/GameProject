extends AudioStreamPlayer

var current = ""
var tunes = {}
var dir = Directory.new()

func _ready():
	dir.open("res://music/Ambient/")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".wav"):
			tunes[file] = load("res://music/Ambient/" + file)
	dir.list_dir_end()

# Current is accessed and changed by the scene, not by this code
func _process(delta: float) -> void:
	if current in tunes and not playing:
		stream = tunes[current]
		play()
	elif not current in tunes:
		stop()
