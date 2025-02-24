extends Body
func _ready_custom()->void:
	pass#Signals.retarget.connect(setTarget)	
#func  setTarget():
#	target = _target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process_custom(_delta:float)->void:
	angle = normalize(angle)
	if get_parent().target!=null:
		var tempAngle := normalize(position.angle_to_point(get_parent().target.position - global_position) + PI/2)
		angle += normalize(tempAngle - angle)/4
		if abs(global_position.distance_to(get_parent().target.position))<1000&&$playerPointer.get_collider()==null:
			shoot()
		else:
			release()
	else:
		release()
