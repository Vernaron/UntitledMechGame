extends Camera2D

# Called when the node enters the scene tree for the first time.
var shaking_list = []
var target : Node2D
func _ready():
	Signals.screen_shake.connect(start_shaking)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func set_target(_target : Node2D):
	target = _target
func _physics_process(delta):
	if((target.position-position).length()>0):
		position += (target.position - position)/20
	shake(delta)
	
func shake(delta):
	if(shaking_list.size() !=0):
		var index = shaking_list.size()-1
		var displacement = 0
		while(index>=0):
			displacement+=shaking_list[index][0]
			shaking_list[index][1]-=delta
			if shaking_list[index][1]<=0:
				shaking_list.pop_at(index)
			index-=1
		position+=Vector2(0, displacement *
		 PlayerInfo.settings["intensity"]).rotated(randf()*360);

func start_shaking(intensity, time):
	if intensity!=0&&time!=0:
		shaking_list.append([intensity, time])
	



