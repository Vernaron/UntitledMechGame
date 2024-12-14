extends Damage_Dealer
class_name Beam
var target_hit = {}
var body
var accuracy_rad
var rotation_offset = 0
var rotation_offset_accel = 0
var offset
func _process(_delta):
	

	position=body.global_position+offset.rotated(body.global_rotation)
	rotation = body.global_rotation + rotation_offset
	var target_hit_1 = get_world_2d().direct_space_state.\
		intersect_ray(PhysicsRayQueryParameters2D.\
		create(global_position+Vector2(aoe/2, 0).rotated(global_rotation), global_position+Vector2(aoe/2, 0).rotated(global_rotation)+Vector2(0, -10000).rotated(global_rotation)))
	var target_hit_2 = get_world_2d().direct_space_state.\
		intersect_ray(PhysicsRayQueryParameters2D.\
		create(global_position+Vector2(-aoe/2, 0).rotated(global_rotation), global_position+Vector2(aoe/2, 0).rotated(global_rotation)+Vector2(0, -10000).rotated(global_rotation)))
	if(target_hit_1!={}&&target_hit_2!={}):
		print( target_hit_1.position, " ", target_hit_2.position)
		if(global_position.distance_squared_to(target_hit_1.position)<global_position.distance_squared_to(target_hit_2.position)):
			target_hit=target_hit_1
	
		else:

			target_hit=target_hit_2
	elif(target_hit_1!={}):
		target_hit=target_hit_1
	else:
		target_hit=target_hit_2 
	if(target_hit!={}):
		final_position =target_hit.position
		if(target_hit.collider is Legs && target_hit.collider.get_collision_layer_value(target)==true):
			enemy_coll = target_hit.collider
	else:
		final_position = global_position+Vector2(0, -10000).rotated(rotation)
	
func _physics_process(_delta):
	if(randf()*accuracy_rad - accuracy_rad/2> rotation_offset):
		rotation_offset_accel= clamp(rotation_offset_accel+.2, -2, 2)
		if rotation_offset >= accuracy_rad/2:rotation_offset_accel=-1
	else:
		rotation_offset_accel=clamp(rotation_offset_accel-.2, -2, 2)
		if rotation_offset <= -accuracy_rad/2:rotation_offset_accel=1
	rotation_offset+= rotation_offset_accel*accuracy_rad*_delta
	rotation_offset = clamp(rotation_offset, -accuracy_rad/2, accuracy_rad/2)
	$Beam.set_length(final_position.distance_to(global_position))
	$BeamLight.texture.height = clamp(final_position.distance_to(global_position), 0, 2000)
	$BeamLight.position.y = -$BeamLight.texture.height/2
	$tipLight.position.y = -final_position.distance_to(global_position)+5
	if(target_hit!={} && target_hit.collider is Legs && target_hit.collider.get_collision_layer_value(target)==true):
		enemy_coll = target_hit.collider
		if(enemy_coll!= null):deal_damage(DAMAGE * _delta, enemy_coll, [rotation-PI/2,final_position])
	

	
func _set_collide(collide : int, _is_colliding: bool):
	target = collide
