extends CharacterBody2D
class_name Legs
enum DASH{BURST, JET}
@export_range(1, 1000) var SPEED : float = 1000.0
@export_range(.1, 1) var ACCELERATION : float =1
var angle : float = 0 
var curr_move_ratio = 0
var curr_dash_ratio = 0
var angle_locked = 0
var camera = null
var root = null
@export_range(.01, 10) var dash_time : float = 0.0
@export_range(1, 10) var dash_cooldown:float = 0.0
@export_range(1, 1000) var dash_speed : float = 1000.0
@export_range(0.1, 1) var turn_radius : float = 1
@export var current_dash_type : DASH =  DASH.BURST
@export var health : float = 1
var curr_dash_time : float = dash_time
var current_dash_cooldown = 0
var current_dash_time = 0
var jet_button_down : bool= false
var is_on_cooldown : bool = false
var is_moving : bool = false

func construct(_name = "", _camera = null, _root = null, _current_legs = {}, _current_body = {}, _weapons_array = []):
	name = _name
	set_camera(_camera)
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
	else:
		if(curr_move_ratio>0):
			curr_move_ratio*=1-clamp((ACCELERATION * delta)*10, 0, 1)
	turn(delta)
	var dash_boost = get_dash_vector(delta)

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
		DASH.BURST:
			dash_boost = Vector2(0, -curr_dash_ratio*5) \
				.rotated(angle_locked) * dash_speed
			if(current_dash_time > 0):
				current_dash_time-=delta
			else:
				curr_dash_ratio*=0.8
		DASH.JET:
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
	var diff = angle - global_rotation
	if(diff > PI): diff-=2*PI
	if(diff < -PI): diff+=2*PI
	diff *=turn_radius * 10
	diff = clamp(diff, -4 * PI *(turn_radius), 4 * PI * (turn_radius))
	rotate(diff * delta)
func set_current_legs(_legs : Dictionary):
	SPEED= _legs["speed"]
	ACCELERATION = _legs["acceleration"]
	dash_time = _legs["dash_time"]
	dash_cooldown = _legs["dash_cooldown"]
	dash_speed = _legs["dash_speed"]
	turn_radius = _legs["turn_radius"]
	health = _legs["health"]
func set_current_body(body : Dictionary):
	$Body.set_current_body(body)
func set_weapons_from_array(weapon_array : Array):
	$Body.set_weapons_from_array(weapon_array)
func set_camera(_camera):
	camera = _camera
	$Body.set_camera(_camera)
func set_root(_root):
	root = _root
	$Body.set_root(_root)
func start_dash():
	match(current_dash_type):
		DASH.BURST:
			if(current_dash_cooldown<=0):
				curr_dash_ratio = 1
				angle_locked = angle
				current_dash_time = dash_time
				current_dash_cooldown = dash_cooldown
		DASH.JET:
			jet_button_down = true
func end_dash():
	jet_button_down=false
	
#Override functions
func _process_custom(_delta):
	pass
func _physics_process_custom(_delta):
	pass
func _get_intended_angle():
	pass
func _construct_custom():
	pass
