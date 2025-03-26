@tool
extends Node
class_name Item_Data
@export var Reload : bool = false
enum Weapon_Type{Bullet, Laser, Missile, Grenade}
enum Loadouts{Strider, Bulwark, SmallTank, SmallHeli, Roamer}
enum DASH{BURST, JET}
var nullhardpoint:Array = [Vector2.ZERO, [] as Array[Tag]]

class Tag:
	var color : Color
	var tag_name : String
	var description : String 
	var hardpoint_description : String
	var valid_tag_list : Array[String]
	func _init(_tag_name : String, _color : Color, 
		_valid_tag_list : Array[String], _description : String, 
		_hardpoint_description : String)->void:
			
		tag_name = _tag_name
		color = _color
		valid_tag_list = _valid_tag_list
		description = _description
		hardpoint_description = _hardpoint_description	
	func has_valid_tag(hardpoint_tag_array : Array[Tag])->bool:
		for hardpoint_tag : Tag in hardpoint_tag_array:
			if valid_tag_list.find(hardpoint_tag.tag_name) !=-1:
				return true
		return false
func assign_tags(tag_name_list: Array[String])->Array[Tag]:
	var temp_list : Array[Tag] = []
	for n in tag_name_list:
		temp_list.push_back(tags[n])
	return temp_list
func get_display_name(equip_name : String, equip_type : String)->String:
	if(equip_name==""):
		return "Empty"
	return resolve_dictionary(equip_type)[equip_name].display_name
func get_description(equip_name : String, equip_type : String)->String:
	if(equip_name==""):
		return ""
	return resolve_dictionary(equip_type)[equip_name].description
func get_image(equip_name:String,equip_type:String)->Resource:
	if(equip_name==""):
		return preload("res://assets/BlankFrames.tres")
	return resolve_dictionary(equip_type)[equip_name].sprite
	
func resolve_dictionary(equip_type : String)->Dictionary:
	match(equip_type):
		"Body":
			return bodies
		"Leg":
			return legs
		"Weapon":
			return weapons
	return {}
class Weapon:
	var bullet_flash: Node2D
	#var root_scene : Node2D
	var body : Node2D
	var reload : float
	var damage : float
	var offset : Vector2 = Vector2.ZERO
	var bullet : Resource
	var projectile_count : int
	var accuracy : float
	var area_of_effect: float
	var type : Weapon_Type
	var projectiles : Array = []
	var is_firing := false
	var curr_reload : float = 0
	var shake_coeff : float 
	var tags : Array[Tag]
	var description : String
	var display_name : String
	var sprite : Resource
	func _init(_reload : float, 
		_damage: float, 
		_projectile_count : int, 
		_bullet : Resource, 
		_type : Weapon_Type, 
		_accuracy :float,
		_tags : Array[Tag],
		_description:String,
		_display_name:String,
		_display_image:Resource,
		 _area_of_effect:float = 0.0,
		 flash:Node2D = null
		)->void:
		if Engine.is_editor_hint(): return
		projectile_count = _projectile_count
		reload = _reload
		damage = _damage
		bullet_flash = flash
		bullet = _bullet
		type = _type
		accuracy = _accuracy
		area_of_effect=_area_of_effect
		tags = _tags
		description = _description
		display_name = _display_name
		sprite = _display_image
		Signals.SettingsChange.connect(settingsChanged)
		if(PlayerInfo.settings!={}):
			shake_coeff = damage * PlayerInfo.settings["intensity"]
		else:
			shake_coeff = damage
	func setOffset(new_offset: Vector2)->void:
		offset = new_offset
	func settingsChanged()->void:
		shake_coeff = damage * PlayerInfo.settings["intensity"]
	func set_body(_body:Body)->void:
		body = _body
	func shoot(delta:float)->void:
		
		match(type):
			Weapon_Type.Bullet:
				curr_reload-=delta
				if(curr_reload<=0):
					for num in range(0, projectile_count):
						var temp_bullet :Damage_Dealer= bullet.instantiate()
						temp_bullet.set_team(body.team)
						temp_bullet.DAMAGE = damage
						temp_bullet.rotation = body.global_rotation + (randf()*accuracy - accuracy/2)*PI/180
						temp_bullet.position=offset.rotated(body.global_rotation)+body.global_position
						
						var temp_flash :PointLight2D= bullet_flash.copy()
						temp_flash.position = offset
						body.add_child(temp_flash.copy())
						Signals.spawn_root.emit(temp_bullet)
						curr_reload=reload	
						if(body.team ==1):
							Signals.screen_shake.emit(shake_coeff/4, .2)
						else:
							Signals.screen_shake.emit(shake_coeff/2, .2)
			Weapon_Type.Laser:
				if !is_firing:
					is_firing = true
					for num in range(0, projectile_count):
						var temp_bullet:Damage_Dealer = bullet.instantiate()
						temp_bullet.set_team(body.team)
						temp_bullet.DAMAGE = damage
						temp_bullet.rotation = body.global_rotation
						temp_bullet.aoe = area_of_effect
						temp_bullet.accuracy_rad = accuracy*PI/180 
						temp_bullet.position=offset.rotated(body.global_rotation) + body.global_position
						temp_bullet.offset = offset
						temp_bullet.body = body
						temp_bullet.visible = false
						projectiles.push_back(temp_bullet)
						Signals.spawn_root.emit(temp_bullet)
				else:
					var accadjusted := accuracy * PI / 180
					for i in range(0, projectiles.size()):
						var target := randf()*2*accadjusted -accadjusted
						if(projectiles[i].rotation>target):
							projectiles[i].rotation-=accadjusted/10 * delta
						else:
							projectiles[i].rotation+=accadjusted/10 * delta
			Weapon_Type.Grenade:
				curr_reload-=delta
				if(curr_reload<=0):
					for num in range(0, projectile_count):
						var temp_bullet :Damage_Dealer= bullet.instantiate()
						temp_bullet.set_team(body.team)
						temp_bullet.DAMAGE = damage
						temp_bullet.rotation = body.global_rotation + (randf()*accuracy - accuracy/2)*PI/180
						temp_bullet.position=offset.rotated(body.global_rotation)+body.global_position
						temp_bullet.aoe = area_of_effect
						var temp_flash :PointLight2D = bullet_flash.copy()
						temp_flash.position = offset
						body.add_child(temp_flash.copy())
						Signals.spawn_root.emit(temp_bullet)
						curr_reload=reload	
						if(body.team ==1):
							Signals.screen_shake.emit(shake_coeff/4, .2)
						else:
							Signals.screen_shake.emit(shake_coeff/2, .2)
			Weapon_Type.Missile:
				pass				
	func release()->void:
		is_firing = false
		match(type):
			Weapon_Type.Bullet:
				pass
			Weapon_Type.Laser:
				deleteProjectiles()
			Weapon_Type.Grenade:
				pass
			Weapon_Type.Missile:
				pass
	func deleteProjectiles()->void:
		var i := projectiles.size()-1
		while i >=0:
			projectiles[i].queue_free()
			i-=1
		projectiles.clear()
	func copy()->Weapon:
		var tempWeapon: = Weapon.new(reload, damage, projectile_count, bullet, type, accuracy, tags,description,display_name, sprite,area_of_effect, bullet_flash)
		tempWeapon.offset = offset
		tempWeapon.body = body
		return tempWeapon

var tags: = {
	"Medium" : Tag.new("Medium",Color.BLACK,["Medium", "Heavy", "Superheavy"],"",""),
	"Heavy" : Tag.new("Heavy",Color.BLACK,["Heavy","Superheavy"],"",""),
	"Superheavy" : Tag.new("Superheavy",Color.BLACK,["Superheavy"],"",""),
	"Beam" : Tag.new("Beam",Color.BLACK,["Universal","Beam"],"",""),
	"Pulse" : Tag.new("Pulse",Color.BLACK,["Universal","Pulse"],"",""),
	"Explosive" : Tag.new("Explosive",Color.BLACK,["Universal","Explosive"],"",""),
	"Cannon" : Tag.new("Cannon",Color.BLACK,["Universal","Cannon"],"",""),
	"Missile" : Tag.new("Missile",Color.BLACK,["Universal","Missile"],"",""),
	"Universal" : Tag.new("Universal", Color.WHITE, ["Universal", "Beam", "Pulse", "Explosive", "Cannon","Missile"],"","")
}
var flashes: = {
	"light_flash" : preload("res://scenes/Bullet_Adjacent/bullet_flash.tscn").instantiate().init(1, Color.hex(0xc88834FF), .01, .1, true),
	"medium_flash" : preload("res://scenes/Bullet_Adjacent/bullet_flash.tscn").instantiate().init(2, Color.hex(0xc88834FF), .01, .3, true)
}
var weapons := {
	#reload, damage, projectile_count, bullet, type, accuracy,size_level, area_of_effect, bullet_flash
	"bolter": Weapon.new(.5, 5, 1,
		preload("res://scenes/Bullet_Adjacent/bullet_simple_small.tscn"), 
		Weapon_Type.Bullet, 1, [tags["Medium"], tags["Cannon"]],
		"bolter gun stuff","Bolter",preload("res://assets/BlankFrames.tres"),
		0.0,flashes["light_flash"]),
	"gatling": Weapon.new(.1, 1, 1, 
		preload("res://scenes/Bullet_Adjacent/bullet_simple_tiny.tscn"), 
		Weapon_Type.Bullet, 5, [tags["Medium"], tags["Cannon"]],
		"Size: S\nDamage: 1\n Reload: .1s\n Accuracy: 5°\n
		little gun go dakka","Gatling", preload("res://assets/BlankFrames.tres"),
		0.0, flashes["light_flash"]),
	"autocannon": Weapon.new(5, 15, 1, 
		preload("res://scenes/Bullet_Adjacent/bullet_simple_large.tscn"), 
		Weapon_Type.Bullet, 1, [tags["Heavy"], tags["Cannon"]],
		"Size: M\nDamage: 15\nReload: 5s\nAccuracy:1°\n
	big gun go boom","Autocannon",preload("res://assets/BlankFrames.tres"),
	 0.0, flashes["medium_flash"]),
	"laser_small": Weapon.new(-1, 2, 1, 
		preload("res://scenes/Bullet_Adjacent/continuous_laser_small.tscn"),
		Weapon_Type.Laser, 2,[tags["Medium"], tags["Beam"]],
		"little laser go bzzz","Small Laser",preload("res://assets/BlankFrames.tres"),
		 2, flashes["light_flash"]),
	"tank_cannon": Weapon.new(1, 3, 1, 
		preload("res://scenes/Bullet_Adjacent/bullet_simple_tiny.tscn"), 
		Weapon_Type.Bullet, 1, [tags["Medium"], tags["Cannon"]],
		"tank gun go pew","Tank Cannon", preload("res://assets/BlankFrames.tres"),
		0.0,flashes["light_flash"]),
	"auto_shotgun":Weapon.new(.2,1,4,preload("res://scenes/Bullet_Adjacent/bullet_simple_small.tscn"),
		Weapon_Type.Bullet,5,[tags["Medium"], tags["Cannon"]],
		"rapid fire auto shotgun", "Auto Shotgun",preload("res://assets/BlankFrames.tres")
		,0,flashes["light_flash"]),
	"thumper": Weapon.new(1, 5, 1,
		preload("res://scenes/Bullet_Adjacent/bullet_explosive_small.tscn"), 
		Weapon_Type.Grenade, 1, [tags["Medium"], tags["Explosive"]],
		"thumper gun stuff","Thumper",preload("res://assets/BlankFrames.tres"),
		175,flashes["light_flash"]),
}

var bodies: = {
	"strider_1":{
		sprite = preload("res://assets/bodies/strider_body_1_frame.tres"),
		armor=5,
		turn_speed = .7,
		collision_array_points=PackedVector2Array([Vector2(0, -52),Vector2(-28, -4),Vector2(-60, -4),\
			Vector2(-60, 36),Vector2(0, 44),Vector2(60, 35),Vector2(60, -3),Vector2(28, -4)]),
		hardpoints=[	
			[Vector2(46, -1), assign_tags(["Beam","Medium","Explosive","Cannon"])],[Vector2(-46, -1), assign_tags(["Beam","Medium","Explosive","Cannon"])],	nullhardpoint,nullhardpoint,nullhardpoint
		],
		display_name = "Strider",
		description = "the strider class body",
	},
	"bulwark_1":{
		sprite = preload("res://assets/bodies/bulwark_body_1_frame.tres"),
		armor = 10,
		turn_speed=.5,
		collision_array_points=PackedVector2Array([Vector2(0,-36),Vector2(-60,-25),Vector2(-60,20),\
		Vector2(-34,34),Vector2(36,34),Vector2(48,-3),Vector2(47,-31),]),
		hardpoints=[
			[Vector2(40, -33), assign_tags(["Beam","Medium","Explosive"])],[Vector2(-48, -26), assign_tags(["Cannon","Heavy","Missile"])],nullhardpoint,nullhardpoint,nullhardpoint
		],
		display_name = "Bulwark",
		description = "the bulwark class body",
	},
	"tank_1":{
		sprite = preload("res://assets/bodies/tank_1_turret_frame.tres"),
		armor=2,
		turn_speed = 1,
		collision_array_points = PackedVector2Array([Vector2(-16,-20),Vector2(-16,24),Vector2(16,24),Vector2(16,-20),]),
		hardpoints = [[Vector2(0, -17), assign_tags(["Explosive","Cannon","Medium"])],nullhardpoint,nullhardpoint,nullhardpoint,nullhardpoint],
		display_name = "Tank",
		description = "the tank class body",
	},
	"heli_1":{
		sprite = preload("res://assets/HeliSmall.tres"),
		armor = 1,
		turn_speed = .8,
		collision_array_points = PackedVector2Array([Vector2(0,-26),Vector2(-35,0),Vector2(-4,19),Vector2(-12,48),Vector2(12,49),Vector2(5,20),Vector2(37,0),]),
		hardpoints = [[Vector2(0, -20), assign_tags(["Explosive","Cannon","Medium"])],nullhardpoint,nullhardpoint,nullhardpoint,nullhardpoint],
		display_name = "Heli",
		description = "the heli class body",
	},
	"roamer_1":{
		sprite = preload("res://assets/bodies/roamer_body_1_frame.tres"),
		armor=3,
		turn_speed = 1,
		collision_array_points=PackedVector2Array([Vector2(-9,-42),Vector2(-23,-35),Vector2(-32,-15),Vector2(-32,24),Vector2(29,25),Vector2(33,19),Vector2(33,-23),Vector2(9,-25),Vector2(7,-36),]),
		hardpoints=[	
			[Vector2(21, -23), [tags["Medium"],tags["Beam"],tags["Cannon"]]],nullhardpoint,	nullhardpoint,nullhardpoint,nullhardpoint
		],
		display_name = "Roamer",
		description = "the roamer class body",
	},
}
var legs: = {
	"strider_1": {
		move_type = "Mech",
		speed = 300,
		acceleration = .7,
		dash_time=.1,
		dash_cooldown=3,
		dash_speed=300,
		dash_type=ItemData.DASH.BURST,
		turn_radius=.25,
		health = 15,
		sprite = preload("res://assets/Strider_Legs_1.tres"),
		display_name = "Strider",
		description = "the strider class legs"
	},
	"bulwark_1": {
		move_type = "Mech",
		speed = 200,
		acceleration=.3,
		dash_time=8,
		dash_cooldown=2,
		dash_speed=50,
		dash_type=ItemData.DASH.JET,
		turn_radius=.2,
		health=30,
		sprite = preload("res://assets/Bulwark_Legs_1.tres"),
		display_name = "Bulwark",
		description = "the bulwark class legs"
	}, 
	"tank_1":{
		move_type = "Tank",
		speed=150,
		acceleration = 0.4, 
		dash_time = 0,
		dash_cooldown = 1,
		dash_speed = 0,
		dash_type=ItemData.DASH.JET,
		turn_radius = .4,
		health = 4,
		sprite = preload("res://assets/Tank_tread_1.tres"),
		display_name = "tank",
		description = "the tank class legs"
	},
	"heli_1":{
		move_type = "Helicopter",
		speed= 300,
		acceleration=0.5,
		dash_time=0,
		dash_cooldown=0,
		dash_speed=0,
		dash_type = ItemData.DASH.JET,
		turn_radius = 10,
		health=2,
		sprite = preload("res://assets/BlankFrames.tres"),
		display_name = "heli",
		description = "the heli's invisible legs"
		
	},
	"roamer_1": {
		move_type = "Mech",
		speed = 400,
		acceleration = .8,
		dash_time=.1,
		dash_cooldown=3,
		dash_speed=200,
		dash_type=ItemData.DASH.BURST,
		turn_radius=.3,
		health = 10,
		sprite = preload("res://assets/Roamer_Legs_1.tres"),
		display_name = "Roamer",
		description = "the roamer class legs",
	},
}
var control_type := {
	"Mech" : {
		collision_track_legs = false,
		wobbles = true, 
		turns = true,
	},
	"Helicopter" : {
		collision_track_legs = false,
		wobbles = false,
		turns = false,
	},
	"Tank" : {
		collision_track_legs = true,
		wobbles = false,
		turns = true, 
	}
}
func _process(_delta:float)->void:
	if Engine.is_editor_hint():
		if(Reload):
			Reload=false
			notify_property_list_changed()
			
