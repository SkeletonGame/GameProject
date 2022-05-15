extends Player

func _ready():
	pass # Replace with function body.


var eye_mood = 'idle'
var animation = 'idle'

func anim_handler():
	match (direction):
		Direction.none:
			animation = "idle"
		Direction.left:
			animation = "strut"
			get_node("AnimatedSprite").set_flip_h(false)
			get_node("Eyes").set_flip_h(false)
		Direction.right:
			animation = "strut"
			get_node("AnimatedSprite").set_flip_h(true)
			get_node("Eyes").set_flip_h(true)
		_: 	
			animation = "idle"
	get_node("Eyes").set_animation(eye_mood)
	get_node("AnimatedSprite").set_animation(animation)

func _physics_process(delta):
	phys_handler(delta)
	anim_handler()
	
