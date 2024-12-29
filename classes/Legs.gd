extends CharacterBody2D
class_name Legs
var richochet_blast = preload("res://particles/bullet_richochet.tscn")

@export_range(1, 1000) var SPEED : float = 1000.0
@export_range(.1, 1) var ACCELERATION : float =1
var angle : float = 0 
var curr_move_ratio = 0
var curr_dash_ratio = 0
var angle_locked = 0
var root = null
var healthZero = false
@export_range(.01, 10) var dash_time : float = 0.0
@export_range(1, 10) var dash_cooldown:float = 0.0
@export_range(1, 1000) var dash_speed : float = 1000.0
@export_range(0.1, 1) var turn_radius : float = 1
@export var current_dash_type : ItemData.DASH =  ItemData.DASH.BURST
@export var health : float = 1
var current_health = health
var curr_dash_time : float = dash_time
var current_dash_cooldown = 0
var current_dash_time = 0
var jet_button_down : bool= false
var is_on_cooldown : bool = false
var is_moving : bool = false
var movement_juice : float = 0
func construct(_name = "", _root = null, _current_legs = {}, _current_body = {}, _weapons_array = []):
	name = _name
	set_root(_root)
	_construct_custom()
	if _current_legs!={}: set_current_legs(_current_legs)
	if _current_body !={}: set_current_body(_current_body)
	if _weapons_array != []:set_weapons_from_array(_weapons_array)
func _process(delta):
	_process_custom(delta)
func _physics_process(delta):
	_physics_process_custom(delta)
	if(is_moving):
		_get_intended_angle()
		angle-=PI/2
		curr_move_ratio=min(1.0, curr_move_ratio+ACCELERATION*delta)
		angle+=movement_juice / 4
	else:
		if(curr_move_ratio>0):
			curr_move_ratio*=1-clamp((ACCELERATION * delta)*10, 0, 1)
		elif(curr_move_ratio<0.1):
			movement_juice = 0
			$LegsSprite.frame = 0
	turn(delta)
	var dash_boost = get_dash_vector(delta)
	$LegsSprite.speed_scale = curr_move_ratio * SPEED/1000
	movement_juice = sin(($LegsSprite.frame +$LegsSprite.frame_progress ) * PI / 6)
	var currScale:Vector2=Vector2.ZERO
	currScale.x = 4+abs(movement_juice)*.4
	currScale.y = 4+abs(movement_juice)*.4
	$LegsSprite.scale = currScale
	$Body/BodySprite.scale = currScale
	if(rotation < 0):
		rotation+=2*PI
	velocity = (Vector2(0,-curr_move_ratio*1.5).rotated(rotation) + \
		Vector2(0, -curr_move_ratio*.5).rotated(angle)) * SPEED + dash_boost
	

	move_and_slide()
	if (current_dash_cooldown > 0):
		current_dash_cooldown-=delta;
		
func get_dash_vector(delta):
	var dash_boost = Vector2.ZERO
	match (current_dash_type):
		ItemData.DASH.BURST:
			dash_boost = Vector2(0, -curr_dash_ratio*5) \
				.rotated(angle_locked) * dash_speed
			if(current_dash_time > 0):
				current_dash_time-=delta
			else:
				curr_dash_ratio*=0.8
		ItemData.DASH.JET:
			if(jet_button_down&&!is_on_cooldown):
				curr_dash_ratio+=ACCELERATION * delta
				curr_dash_time-=delta
				if(curr_dash_time<=0):
					curr_dash_time=0
					is_on_cooldown=true
			else:
				curr_dash_ratio*=1-clamp((ACCELERATION * delta)*10, 0, 1)
				if(curr_dash_time<dash_time):
					curr_dash_time+=dash_cooldown*delta
				if(curr_dash_time>=dash_time):
					curr_dash_time=dash_time
					is_on_cooldown = false
			dash_boost = Vector2(0, -curr_dash_ratio*5) \
				.rotated(rotation) * dash_speed	
	return dash_boost

	
func turn(delta):
	var diff = normalize(angle - global_rotation)
	diff *=turn_radius * 10
	diff = clamp(diff, -4 * PI *(turn_radius), 4 * PI * (turn_radius))
	rotate(diff * delta)
func normalize(value):
	if(value > PI): return value-2*PI
	if(value < -PI): return value+2*PI
	return value
func set_current_legs(_legs : Dictionary):
	SPEED= _legs["speed"]
	ACCELERATION = _legs["acceleration"]
	dash_time = _legs["dash_time"]
	dash_cooldown = _legs["dash_cooldown"]
	dash_speed = _legs["dash_speed"]
	turn_radius = _legs["turn_radius"]
	health = _legs["health"]
	current_health = health
	current_dash_type=_legs["dash_type"]
	$LegsSprite.sprite_frames = _legs.sprite

	$LegsSprite.play()
func set_current_body(body : Dictionary):
	$Body.set_current_body(body)
	$LegCollisionPolygon.set_array(body["collision_array_points"])
	$Occluder.occluder.polygon = body["collision_array_points"]
func set_weapons_from_array(weapon_array : Array):
	$Body.set_weapons_from_array(weapon_array)

func set_root(_root):
	root = _root
	$Body.set_root(_root)
func start_dash():
	match(current_dash_type):
		ItemData.DASH.BURST:
			if(current_dash_cooldown<=0):
				curr_dash_ratio = 1
				angle_locked = angle
				current_dash_time = dash_time
				current_dash_cooldown = dash_cooldown
		ItemData.DASH.JET:
			jet_button_down = true
func end_dash():
	jet_button_down=false
func set_team(_team):
	$Body.team=_team	
	
func damage_inflict(damage):
	current_health -=damage * 20/($Body.armor + 20)
	if(current_health <= 0):
		healthZero = true
func resolve_particles(location, bullet_spark, laser_spark, damage):
	if PlayerInfo.settings["particles"] <=.001: return
	if bullet_spark:
		var temp = richochet_blast.instantiate()
		temp.set_damage(damage)
		temp.rotation = location[0]
		temp.position = location[1]
		root.add_child(temp)
	
func _ready():
	_ready_custom()
#Override functions
func _ready_custom():
	pass
func _process_custom(_delta):
	pass
func _physics_process_custom(_delta):
	pass
func _get_intended_angle():
	pass
func _construct_custom():
	pass
func _take_damage(_target, _location=null, _bullet_spark=false, _laser_spark=false):
	pass

