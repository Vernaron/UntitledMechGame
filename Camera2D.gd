extends Camera2D

var intensity = ProjectSettings.get_setting("global/shake_intensity")
# Called when the node enters the scene tree for the first time.
var shaking_list = []
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	if((%Legs.position-position).length()>0):
		position += (%Legs.position - position)/20
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
	



