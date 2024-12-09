extends Body




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process_custom(_delta):
	angle = position.angle_to(PlayerInfo.target.global_position - global_position) - PI/2

