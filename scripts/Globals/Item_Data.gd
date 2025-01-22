@tool
extends Node
class_name Item_Data
@export var Reload : bool = false
enum Weapon_Type{Bullet, Laser, Missile, Grenade}
enum Basic_Enemy{Strider, Bulwark, SmallTank, SmallHeli, Roamer}
enum DASH{BURST, JET}
var nullhardpoint = [Vector2.ZERO, -1]
class Weapon:
	var bullet_flash: Node2D
	#var root_scene : Node2D
	var body : Node2D
	var reload : float
	var damage : float
	var offset : Vector2 = Vector2.ZERO
	var bullet : Resource
	var projectile_count : float
	var accuracy : float
	var area_of_effect: float
	var type : Weapon_Type
	var projectiles : Array = []
	var is_firing = false
	var curr_reload : float = 0
	var shake_coeff : float 
	var size_level : int
	func _init(_reload, _damage: float, _projectile_count, _bullet, _type, _accuracy, _size_level, _area_of_effect = 0.0, flash = "no_flash"):
		projectile_count = _projectile_count
		reload = _reload
		damage = _damage
		bullet_flash = flash
		bullet = _bullet
		type = _type
		accuracy = _accuracy
		area_of_effect=_area_of_effect
		size_level = _size_level
		Signals.SettingsChange.connect(settingsChanged)
		if(PlayerInfo.settings!={}):
			shake_coeff = damage * PlayerInfo.settings["intensity"]
		else:
			shake_coeff = damage
	func setOffset(new_offset: Vector2):
		offset = new_offset
	func settingsChanged():
		shake_coeff = damage * PlayerInfo.settings["intensity"]
	func set_body(_body):
		body = _body
	func shoot(delta):
		
		match(type):
			Weapon_Type.Bullet:
				curr_reload-=delta
				if(curr_reload<=0):
					for num in range(0, projectile_count):
						var temp_bullet = bullet.instantiate()
						temp_bullet.set_team(body.team)
						temp_bullet.DAMAGE = damage
						temp_bullet.rotation = body.global_rotation + (randf()*accuracy - accuracy/2)*PI/180
						temp_bullet.position=offset.rotated(body.global_rotation)+body.global_position
						
						var temp_flash = bullet_flash.copy()
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
						var temp_bullet = bullet.instantiate()
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
					var accadjusted = accuracy * PI / 180
					for i in range(0, projectiles.size()):
						var target = randf()*2*accadjusted -accadjusted
						if(projectiles[i].rotation>target):
							projectiles[i].rotation-=accadjusted/10 * delta
						else:
							projectiles[i].rotation+=accadjusted/10 * delta
			Weapon_Type.Grenade:
				pass
			Weapon_Type.Missile:
				pass				
	func release():
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
	func deleteProjectiles():
		var i = projectiles.size()-1
		while i >=0:
			projectiles[i].queue_free()
			i-=1
		projectiles.clear()
	func copy():
		var tempWeapon = Weapon.new(reload, damage, projectile_count, bullet, type, accuracy,size_level, area_of_effect, bullet_flash)
		tempWeapon.offset = offset
#		tempWeapon.root_scene = root_scene
		tempWeapon.body = body
		return tempWeapon
var flashes = {
	"light_flash" : preload("res://scenes/Bullet_Adjacent/bullet_flash.tscn").instantiate().init(1, Color.hex(0xc88834FF), .01, .1, true),
	"medium_flash" : preload("res://scenes/Bullet_Adjacent/bullet_flash.tscn").instantiate().init(2, Color.hex(0xc88834FF), .01, .3, true)

}
var weapons = {
	#reload, damage, projectile_count, bullet, type, accuracy,size_level, area_of_effect, bullet_flash
	"bolter": Weapon.new(.5, 5, 1,
		preload("res://scenes/Bullet_Adjacent/bullet_simple_small.tscn"), 
		Weapon_Type.Bullet, 1, 1, 0.0,flashes["light_flash"]),
	"gatling": Weapon.new(.1, 1, 1, 
		preload("res://scenes/Bullet_Adjacent/bullet_simple_tiny.tscn"), 
		Weapon_Type.Bullet, 5, 1,  0.0, flashes["light_flash"]),
	"autocannon": Weapon.new(5, 15, 1, 
		preload("res://scenes/Bullet_Adjacent/bullet_simple_large.tscn"), 
		Weapon_Type.Bullet, 1, 2,  0.0, flashes["medium_flash"]),
	"laser_small": Weapon.new(-1, 2, 1, 
		preload("res://scenes/Bullet_Adjacent/continuous_laser_small.tscn"),
		Weapon_Type.Laser, 2,1, 2, flashes["light_flash"]),
	"tank_cannon": Weapon.new(1, 3, 1, 
		preload("res://scenes/Bullet_Adjacent/bullet_simple_tiny.tscn"), 
		Weapon_Type.Bullet, 1, 1, 0.0,flashes["light_flash"]),
}
var weapon_descriptions = {
	"":["", ""],
	"bolter": ["bolter gun stuff", "Bolter"],
	"gatling": ["Size: S\nDamage: 1\n Reload: .1s\n Accuracy: 5°\n
	little gun go dakka", "Gatling"],
	"autocannon":["Size: M\nDamage: 15\nReload: 5s\nAccuracy:1°\n
	big gun go boom", "Autocannon"],
	"laser_small":["little laser go bzzz", "Small Laser"],
	"tank_cannon":["tank gun go pew", "Tank Cannon"], 
	
}
var body_descriptions = {
	"":"",
	"strider_1": "the strider class body",
	"bulwark_1": "the bulwark class body",
	"roamer_1" : "the roamer class body"
}
var leg_descriptions = {
	"":"",
	"strider_1": "the strider class legs",
	"bulwark_1": "the bulwark class legs",
	"roamer_1" : "the roamer class legs"
}
var bodies = {
	"strider_1":{
		sprite = preload("res://assets/bodies/strider_body_1_frame.tres"),
		armor=5,
		turn_speed = 1,
		collision_array_points=PackedVector2Array([Vector2(0, -52),Vector2(-28, -4),Vector2(-60, -4),\
			Vector2(-60, 36),Vector2(0, 44),Vector2(60, 35),Vector2(60, -3),Vector2(28, -4)]),
		hardpoints=[	
			[Vector2(46, -1), 1],[Vector2(-46, -1), 1],	nullhardpoint,nullhardpoint,nullhardpoint
		],
		name = "Strider"
	},
	"bulwark_1":{
		sprite = preload("res://assets/bodies/bulwark_body_1_frame.tres"),
		armor = 10,
		turn_speed=.5,
		collision_array_points=PackedVector2Array([Vector2(0,-36),Vector2(-60,-25),Vector2(-60,20),\
		Vector2(-34,34),Vector2(36,34),Vector2(48,-3),Vector2(47,-31),]),
		hardpoints=[
			[Vector2(40, -33), 1],[Vector2(-48, -26), 2],nullhardpoint,nullhardpoint,nullhardpoint
		],
		name = "Bulwark"
	},
	"tank_1":{
		sprite = preload("res://assets/bodies/tank_1_turret_frame.tres"),
		armor=2,
		turn_speed = 2,
		collision_array_points = PackedVector2Array([Vector2(-16,-20),Vector2(-16,24),Vector2(16,24),Vector2(16,-20),]),
		hardpoints = [[Vector2(0, -17), 1],nullhardpoint,nullhardpoint,nullhardpoint,nullhardpoint]
	},
	"heli_1":{
		sprite = preload("res://assets/HeliSmall.tres"),
		armor = 1,
		turn_speed = 1,
		collision_array_points = PackedVector2Array([Vector2(0,-26),Vector2(-35,0),Vector2(-4,19),Vector2(-12,48),Vector2(12,49),Vector2(5,20),Vector2(37,0),]),
		hardpoints = [[Vector2(0, -20), 1],nullhardpoint,nullhardpoint,nullhardpoint,nullhardpoint]
	},
	"roamer_1":{
		sprite = preload("res://assets/bodies/roamer_body_1_frame.tres"),
		armor=3,
		turn_speed = 2,
		collision_array_points=PackedVector2Array([Vector2(-9,-42),Vector2(-23,-35),Vector2(-32,-15),Vector2(-32,24),Vector2(29,25),Vector2(33,19),Vector2(33,-23),Vector2(9,-25),Vector2(7,-36),]),
		hardpoints=[	
			[Vector2(21, -23), 1],nullhardpoint,	nullhardpoint,nullhardpoint,nullhardpoint
		],
		name = "Roamer"
	},
}
var legs = {
	"strider_1": {
		move_type = "Mech",
		speed = 500,
		acceleration = .7,
		dash_time=.1,
		dash_cooldown=3,
		dash_speed=300,
		dash_type=ItemData.DASH.BURST,
		turn_radius=.3,
		health = 15,
		sprite = preload("res://assets/Strider_Legs_1.tres"),
		name = "Strider"
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
		name = "Bulwark"
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
		sprite = preload("res://assets/Tank_tread_1.tres")
	},
	"heli_1":{
		move_type = "Helicopter",
		speed= 500,
		acceleration=0.5,
		dash_time=0,
		dash_cooldown=0,
		dash_speed=0,
		dash_type = ItemData.DASH.JET,
		turn_radius = 10,
		health=2,
		sprite = preload("res://assets/BlankFrames.tres")
	},
	"roamer_1": {
		move_type = "Mech",
		speed = 600,
		acceleration = .8,
		dash_time=.1,
		dash_cooldown=3,
		dash_speed=200,
		dash_type=ItemData.DASH.BURST,
		turn_radius=.4,
		health = 10,
		sprite = preload("res://assets/Roamer_Legs_1.tres"),
		name = "Roamer"
	},
}
var control_type = {
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
func _process(_delta):
	if Engine.is_editor_hint():
		if(Reload):
			Reload=false
			notify_property_list_changed()
			
