extends Legs
var curr_type : ItemData.Basic_Enemy = ItemData.Basic_Enemy.Strider

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

func _physics_process_custom(_delta):
	if(healthZero):
		queue_free()
	if(abs(position.distance_to(PlayerInfo.target.position)) < 1000):
		is_moving = true
		if(abs(position.distance_to(PlayerInfo.target.position)) < 500):
			curr_move_ratio = clamp(curr_move_ratio, 0, 0.7)
			if(abs(position.distance_to(PlayerInfo.target.position)) < 200):
				curr_move_ratio = clamp(curr_move_ratio, 0, 0.3)
		
	else:
		is_moving = false
func _get_intended_angle():
	var direction= position.direction_to(PlayerInfo.target.position)
	angle = atan2(-direction.y, -direction.x)
func _take_damage(damage, location=null, bullet_spark=false, laser_spark=false):
	damage_inflict(damage)
	resolve_particles(location, bullet_spark, laser_spark, damage)
	camera.start_shaking(damage/2, .2)
