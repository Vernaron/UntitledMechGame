extends Camera2D
@export var defaultZoom :float
@export var zoomShiftIntensity: float 
# Called when the node enters the scene tree for the first time.
var shaking_list = []
var target : Node2D
var goingUp = false
func _ready():
	Signals.screen_shake.connect(start_shaking)
	Signals.teleport_player.connect(teleport)
	Signals.ascend.connect(going_up)
	Signals.descend.connect(going_down)

func teleport(location:Vector2):
	var tele_offset:Vector2 =position-target.position
	position = location+tele_offset
	if(goingUp):
		zoom+=Vector2(zoomShiftIntensity,zoomShiftIntensity)
	else:
		zoom-=Vector2(zoomShiftIntensity,zoomShiftIntensity)
func going_down(_null):
	goingUp = false
func going_up(_null):
	goingUp = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func set_target(_target : Node2D):
	target = _target
func _physics_process(delta):
	if((target.position-position).length()>0):
		position += (target.position - position)/20
	shake(delta)
	if(zoom.x!=defaultZoom):
		if(abs(zoom.x-defaultZoom)<.001):
			zoom =Vector2(defaultZoom, defaultZoom)
		else:
			zoom-=Vector2((zoom.x-defaultZoom)/10, (zoom.y-defaultZoom)/10)
	
func shake(delta):
	if(shaking_list.size() !=0):
		var index = shaking_list.size()-1
		var displacement = 0
		var sizemod =1+ shaking_list.size()/10.0
		while(index>=0):
			displacement+=shaking_list[index][0]
			shaking_list[index][1]-=delta
			if shaking_list[index][1]<=0:
				shaking_list.pop_at(index)
			index-=1
		displacement/=sizemod
		position+=Vector2(0, displacement *
		 PlayerInfo.settings["intensity"]).rotated(randf()*360);

func start_shaking(intensity, time):
	if intensity!=0&&time!=0:
		shaking_list.append([intensity, time])
	
