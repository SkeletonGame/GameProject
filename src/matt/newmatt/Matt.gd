extends KinematicBody2D

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("left"):
		move_and_collide(Vector2(-10, 0))
