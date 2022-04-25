extends KinematicBody2D

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		move_and_collide(Vector2(-10, 0))
	if Input.is_action_pressed("right"):
		move_and_collide(Vector2(10, 0))
