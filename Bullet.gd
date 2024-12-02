extends CharacterBody2D
class_name Bullet

@export var SPEED = 3000.0




func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(rotation)
	
	move_and_slide()
