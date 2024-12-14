extends Body




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process_custom(_delta):
	angle = position.angle_to_point(PlayerInfo.target.global_position - global_position) + PI/2
	if abs(global_position.distance_to(PlayerInfo.target.position))<1000:
		shoot()
	else:
		release()


