extends Node2D
class_name Body
@export var RELOAD_SPEED = 1.0
var curr_reload = 0
var angle = 0
@export_range(.1, 1) var ACCELERATION : float =1
@export var armor:float =1
@export_range(1, 5) var hardpoints
@export_range(0, 2) var team : int
var hardpoint_arr = []
var delta_buildup = 0
#Hardpoint that encapsulates a weapon
class Hardpoint:
	var weapon : ItemData.Weapon
	var tier : int = 0
	var offset: Vector2
	func _init(_tier, _offset):
		offset = _offset
		tier = _tier
	func set_weapon(_weapon : ItemData.Weapon):
		weapon = _weapon
	func shoot(delta):
		if weapon != null:
			weapon.shoot(delta)
	func release():
		if weapon!=null:
			weapon.release()


func set_current_body(body : Dictionary):
	armor = body["armor"]
	ACCELERATION = body["turn_speed"]
	hardpoints = body["hardpoint_count"]
	for hardpoint in body["hardpoints"]:
		hardpoint_arr.append(Hardpoint.new(hardpoint[1], hardpoint[0]))
	$BodySprite.texture = body["sprite"]
	
func set_weapon(weapon, index):
	weapon.set_body(self)
	weapon.offset = hardpoint_arr[index].offset
	hardpoint_arr[index].set_weapon(weapon.copy())
func set_weapons_from_array(weapon_array):
	for i in range(0, min(weapon_array.size(), hardpoints)):
		set_weapon(weapon_array[i],i)

func _process(delta):
	_process_custom(delta)
	delta_buildup+=delta
	if(curr_reload>0):
		curr_reload-=delta
func _physics_process(delta):
	_physics_process_custom(delta)
	turn(delta)
func shoot():
	for hardpoint in hardpoint_arr:
		hardpoint.shoot(delta_buildup)
	delta_buildup=0
func release():
	for hardpoint in hardpoint_arr:
		hardpoint.release()

func turn(delta):
	var diff = normalize(angle - global_rotation)
	diff *=ACCELERATION * 10
	diff = clamp(diff, -4 * PI *(ACCELERATION), 4 * PI * (ACCELERATION))
	rotate(diff * delta)
func normalize(value):
	if(value > PI): return value-2*PI
	if(value < -PI): return value+2*PI
	return value
func _ready():
	_ready_custom()
func _ready_custom():
	pass
func _process_custom(_delta):
	pass
func _physics_process_custom(_delta):
	pass

