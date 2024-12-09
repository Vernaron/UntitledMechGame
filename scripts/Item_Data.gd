extends Node
class_name Item_Data
enum Weapon_Type{Bullet, Laser, Missile, Grenade}
enum Basic_Enemy{Strider, Bulwark}
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
	var is_firing = false
	var curr_reload : float = 0
	var shake_coeff : float 
	func _init(_reload, _damage, _projectile_count, _bullet, _type, _accuracy, _area_of_effect):
		projectile_count = _projectile_count
		reload = _reload
		damage = _damage
		bullet = _bullet
		type = _type
		accuracy = _accuracy
		area_of_effect=_area_of_effect
		shake_coeff = sqrt(damage)
	func setOffset(new_offset: Vector2):
		offset = new_offset
	func set_references(_root_scene, _body, _camera):
		root_scene = _root_scene
		body = _body
		camera = _camera
	func shoot(delta):
		is_firing = true
		match(type):
			Weapon_Type.Bullet:
				curr_reload-=delta
				if(curr_reload<=0):
					for num in range(0, projectile_count):
						var temp_bullet = bullet.instantiate()
						temp_bullet.rotation = body.global_rotation
						temp_bullet.position=offset.rotated(body.global_rotation)+body.global_position
						root_scene.add_child(temp_bullet)
						curr_reload=reload	
						camera.start_shaking(shake_coeff, .2)
			Weapon_Type.Laser:
				pass
			Weapon_Type.Grenade:
				pass
			Weapon_Type.Missile:
				pass				
	func release():
		is_firing = false
	func copy():
		var tempWeapon = Weapon.new(reload, damage, projectile_count, bullet, type, accuracy, area_of_effect)
		tempWeapon.offset = offset
		tempWeapon.root_scene = root_scene
		tempWeapon.body = body
		tempWeapon.camera = camera
		return tempWeapon
var weapons = {
	"bolter": Weapon.new(.5, 1, 1, preload("res://scenes/bullet.tscn"), Weapon_Type.Bullet, 1, 0),
	
}
var bodies = {
	"strider_1":{
		armor=5,
		hardpoint_count=2,
		turn_speed = 1,
		hardpoints=[
			[Vector2(-10, 1), 1],[Vector2(10, 1), 1]
		]
		
	}
}
var legs = {
	"strider_1": {
		speed = 600,
		acceleration = .4,
		dash_time=.1,
		dash_cooldown=2,
		dash_speed=600,
		turn_radius=.5,
		health = 100
	}
}
