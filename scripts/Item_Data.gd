@tool
extends Node
class_name Item_Data
@export var Reload : bool = false
enum Weapon_Type{Bullet, Laser, Missile, Grenade}
enum Basic_Enemy{Strider, Bulwark}
enum DASH{BURST, JET}
class Weapon:
	var root_scene : Node2D
	var body : Node2D
	var camera : Node2D
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
	func _init(_reload, _damage: float, _projectile_count, _bullet, _type, _accuracy, _size_level, _area_of_effect = 0.0):
		projectile_count = _projectile_count
		reload = _reload
		damage = _damage
		
		bullet = _bullet
		type = _type
		accuracy = _accuracy
		area_of_effect=_area_of_effect
		size_level = _size_level
		shake_coeff = damage
	func setOffset(new_offset: Vector2):
		offset = new_offset
	func set_references(_root_scene, _body, _camera):
		root_scene = _root_scene
		body = _body
		camera = _camera
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
						root_scene.add_child(temp_bullet)
						curr_reload=reload	
						if(body.team ==1):
							camera.start_shaking(shake_coeff/4, .2)
						else:
							camera.start_shaking(shake_coeff/2, .2)
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
						
						root_scene.add_child(temp_bullet)
				else:
					for i in range(0, projectiles.size()):
						var target = (randf()*2*accuracy - accuracy)*PI/180
						if(projectiles[i].rotation>target):
							projectiles[i].rotation-=accuracy/10 * PI/180* delta
						else:
							projectiles[i].rotation+=accuracy/10 * PI/180* delta
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
		var tempWeapon = Weapon.new(reload, damage, projectile_count, bullet, type, accuracy,size_level, area_of_effect)
		tempWeapon.offset = offset
		tempWeapon.root_scene = root_scene
		tempWeapon.body = body
		tempWeapon.camera = camera
		return tempWeapon
var weapons = {
	#reload, damage, projectile_count, bullet, type, accuracy,size_level, area_of_effect=0
	"bolter": Weapon.new(.5, 5, 1, preload("res://scenes/bullet_simple_small.tscn"), Weapon_Type.Bullet, 1, 1),
	"gatling": Weapon.new(.1, 1, 1, preload("res://scenes/bullet_simple_small.tscn"), Weapon_Type.Bullet, 5, 1),
	"autocannon": Weapon.new(5, 15, 1, preload("res://scenes/bullet_simple_large.tscn"), Weapon_Type.Bullet, 1, 2),
	"laser_small": Weapon.new(-1, 2, 1, preload("res://scenes/continuous_laser_small.tscn"),Weapon_Type.Laser, 2,1, 2)
}
@export var bodies = {
	"strider_1":{
		sprite = preload("res://assets/bodies/Strider_body_1.png"),
		armor=5,
		hardpoint_count=2,
		turn_speed = 7,
		collision_array_points=PackedVector2Array([Vector2(0, -52),Vector2(-28, -4),Vector2(-60, -4),\
			Vector2(-60, 36),Vector2(0, 44),Vector2(60, 35),Vector2(60, -3),Vector2(28, -4)]),
		hardpoints=[	
			[Vector2(46, -1), 1],[Vector2(-46, -1), 1],	
		]
		
	},
	"bulwark_1":{
		sprite = preload("res://assets/bodies/Bulwark_body_1.png"),
		armor = 10,
		hardpoint_count = 2, 
		turn_speed=.5,
		collision_array_points=PackedVector2Array([Vector2(0,-36),Vector2(-60,-25),Vector2(-60,20),\
		Vector2(-34,34),Vector2(36,34),Vector2(48,-3),Vector2(47,-31),]),
		hardpoints=[
			[Vector2(40, -28), 2],[Vector2(-46, -24), 1],
		]
	}
}
var legs = {
	"strider_1": {
		speed = 600,
		acceleration = .7,
		dash_time=.1,
		dash_cooldown=2,
		dash_speed=600,
		dash_type=ItemData.DASH.BURST,
		turn_radius=.5,
		health = 100,
		sprite = preload("res://assets/Strider_Legs_1.tres")
	},
	"bulwark_1": {
		speed = 300,
		acceleration=.3,
		dash_time=8,
		dash_cooldown=2,
		dash_speed=100,
		dash_type=ItemData.DASH.JET,
		turn_radius=.3,
		health=400,
		sprite = preload("res://assets/Bulwark_Legs_1.tres")
	}
}
func _process(_delta):
	if Engine.is_editor_hint():
		if(Reload):
			Reload=false
			notify_property_list_changed()
			
