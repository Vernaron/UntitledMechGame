extends Sprite2D

var bullet = preload("res://bullet.tscn")
@export var RELOAD_SPEED = 1.0
var curr_reload = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("shoot")):
		shoot()
	if(curr_reload>0):
		curr_reload-=delta
func _physics_process(delta):
	look_at(get_global_mouse_position())
	rotate(PI/2)
func shoot():
	if(curr_reload<=0):
		curr_reload = RELOAD_SPEED
		var curr_bullet=bullet.instantiate()
		curr_bullet.rotation = global_rotation
		curr_bullet.position = global_position
		owner.add_child(curr_bullet)
		%mainCamera.start_shaking(4, .1)

