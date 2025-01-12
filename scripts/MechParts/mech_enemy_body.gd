extends Body
var target : Vector2 = Vector2.ZERO
func _ready_custom():
	Signals.retarget.connect(setTarget)	
func  setTarget(_target):
	target = _target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process_custom(_delta):
	angle = normalize(angle)
	var tempAngle = normalize(position.angle_to_point(target - global_position) + PI/2)
	angle += normalize(tempAngle - angle)/4
	if abs(global_position.distance_to(target))<1000&&$playerPointer.get_collider()==null:
		shoot()
	else:
		release()
