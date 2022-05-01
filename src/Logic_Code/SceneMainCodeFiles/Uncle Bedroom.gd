extends Node2D

func _ready() -> void:
	get_node("Matt/KinematicMatt").jump_lock = true

var scene_commands = {
	"Cut The Music": false
}
func _process(delta: float) -> void:
	if scene_commands["Cut The Music"]:
		get_node("Ambient Music").current = ""
