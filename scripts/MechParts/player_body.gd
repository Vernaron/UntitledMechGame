extends Body

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	Signals.unpause.connect(unpause);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_custom(_delta:float)->void:
	if(Input.is_action_pressed("shoot")):
			shoot()
	elif(Input.is_action_just_released("shoot")): release()
	

func _physics_process_custom(_delta:float)->void:
	
	angle = position.angle_to_point((get_global_mouse_position() - global_position)) + PI/2
func unpause()->void:
	release()
