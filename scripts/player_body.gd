extends Body


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_custom(_delta):
	if(Input.is_action_pressed("shoot")):
		shoot()
func _physics_process_custom(_delta):
	angle = position.angle_to((get_global_mouse_position() - global_position)) - PI/2