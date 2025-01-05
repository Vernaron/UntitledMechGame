extends Legs
var curr_type : ItemData.Basic_Enemy = ItemData.Basic_Enemy.Strider
var target : Vector2 = Vector2.ZERO

@onready var navrid = get_world_2d().get_navigation_map()
var currPath = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]
@export var attention_span : float
@export var swap_time: float
var time_lost_vision:float=0
var time_gained_vision:float = 0
var super_angle = angle
enum pathing{direct=0, nav=1}
var path_type :pathing=pathing.direct
var path_update:int = 0
var navAngle:float = 0
var angleOffset:float = 0
var distOffset : float = 0
var wallOffset : float = 0
@export var move_range=2000
var angleOffsetCooldown:float = 0
func _ready_custom():
	Signals.retarget.connect(setTarget)	
func  setTarget(_target):
	target = _target
	if path_type==pathing.nav&&path_update==0&&global_position.distance_to(target)<move_range\
		&&get_parent().process_mode!=Node.PROCESS_MODE_DISABLED: 
		calc_path()
	path_update=(path_update+1)%3
func calc_path():
	currPath = NavigationServer2D.map_get_path(navrid, global_position, target, false)
	navAngle=currPath[1].angle_to_point(currPath[0])		
	#
func _construct_custom():
	match(curr_type):
		ItemData.Basic_Enemy.Strider:
			set_current_body(ItemData.bodies["strider_1"])
			set_current_legs(ItemData.legs["strider_1"])
			set_weapons_from_array([ItemData.weapons["bolter"],ItemData.weapons["bolter"]])
		ItemData.Basic_Enemy.Bulwark:
			pass
	
	
func set_type(_type: ItemData.Basic_Enemy):
	curr_type = _type
	_construct_custom()

func _physics_process_custom(delta):
	angleOffsetCooldown-=delta
	if(angleOffsetCooldown<=0):
		angleOffsetCooldown+=1+randf()*3
		if angleOffset<=0:angleOffset=PI/6+(2*PI/6)*randf()
		else:angleOffset=-PI/6-(2*PI/6)*randf()
	$Body/playerPointer.target_position.y = -target.distance_to($Body/playerPointer.global_position)
	if(healthZero):
		queue_free()
	if($Body/playerPointer.get_collider()!=null):
		time_lost_vision+=delta
		time_gained_vision=0
	else:
		time_lost_vision=0
		time_gained_vision+=delta
	if(time_lost_vision>swap_time&&path_type==pathing.direct):
		path_type=pathing.nav
		path_update=0
		
	elif time_gained_vision>swap_time&&path_type==pathing.nav:
		path_type=pathing.direct
		
	if(abs(position.distance_to(target)) < move_range):
		is_moving = true
		if(abs(position.distance_to(target)) < move_range/2.0):
			if angleOffset>0:
				distOffset=PI/2
			else:
				distOffset=-PI/2
		
		else:
			distOffset*=.8
		if(touching_wall):
			if angleOffset>0:
				wallOffset=-PI/2
			else:
				wallOffset=PI/2
		else:
			wallOffset*=0.8
		
	else:
		is_moving = false
func _get_intended_angle():
	var tempAngle=0
	
	if(path_type==pathing.direct):
		var direction= position.direction_to(target)
		tempAngle = normalize(atan2(-direction.y, -direction.x) + angleOffset+distOffset+wallOffset)
		tempAngle+=normalize(tempAngle-normalize(angle))/6
	elif(path_type==pathing.nav):
		tempAngle=navAngle
	angle = tempAngle
func _take_damage(damage, location=null, bullet_spark=false, laser_spark=false):
	damage_inflict(damage)
	resolve_particles(location, bullet_spark, laser_spark, damage)
	Signals.screen_shake.emit(damage/2, .2)
