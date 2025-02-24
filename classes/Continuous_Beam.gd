extends Damage_Dealer
class_name Beam
var target_hit :Object= null
var body :Body
var accuracy_rad:float
var rotation_offset :float= 0
var rotation_offset_accel :float= 0
var offset:Vector2
func _ready_custom()->void:
	$ray_1.position.x = -aoe/2
	$ray_2.position.x = aoe/2
func _process(_delta:float)->void:
	if(!(is_instance_valid(body))):
		queue_free()
		return

	position=body.global_position+offset.rotated(body.global_rotation)
	rotation = body.global_rotation + rotation_offset
	if $ray_1.get_collider()!=null&&$ray_2.get_collider()!=null:
		if global_position.distance_to($ray_1.get_collider().position)>global_position.distance_to($ray_1.get_collider().position):
			target_hit=$ray_2.get_collider()
			final_position=$ray_2.get_collision_point()
		else:
			target_hit=$ray_1.get_collider()
			final_position=$ray_1.get_collision_point()
	elif $ray_1.is_colliding():
		target_hit=$ray_1.get_collider()
		final_position=$ray_1.get_collision_point()
	elif($ray_2.is_colliding()):
		target_hit=$ray_2.get_collider()
		final_position=$ray_2.get_collision_point()
	else:
		target_hit=null
	if(target_hit!=null):
		#final_position =target_hit.global_position
		if(target_hit!=null&&target_hit is Legs && target_hit.get_collision_layer_value(target)==true):
			enemy_coll = target_hit
	else:
		final_position = global_position+Vector2(0, -4000).rotated(rotation)
	
func _physics_process(_delta:float)->void:
	if(randf()*accuracy_rad - accuracy_rad/2> rotation_offset):
		rotation_offset_accel= clamp(rotation_offset_accel+.2, -2, 2)
		if rotation_offset >= accuracy_rad/2:rotation_offset_accel=-1
	else:
		rotation_offset_accel=clamp(rotation_offset_accel-.2, -2, 2)
		if rotation_offset <= -accuracy_rad/2:rotation_offset_accel=1
	rotation_offset+= rotation_offset_accel*accuracy_rad*_delta
	rotation_offset = clamp(rotation_offset, -accuracy_rad/2, accuracy_rad/2)
	$Beam.set_length(final_position.distance_to(global_position))
	#$BeamLight.texture.height = clamp(final_position.distance_to(global_position), 0, 4000)
	#$BeamLight.position.y = -$BeamLight.texture.height/2
	$BeamLight.scale.y = final_position.distance_to(global_position) / 64
	$tipLight.position.y = -final_position.distance_to(global_position)+5
	if(target_hit!=null && target_hit is Legs && target_hit.get_collision_layer_value(target)==true):
		enemy_coll = target_hit
		if(enemy_coll!= null):deal_damage(DAMAGE * _delta, enemy_coll, [rotation-PI/2,final_position])
	

	
func _set_collide(collide : int, _is_colliding: bool)->void:
	target = collide
	$ray_1.set_collision_mask_value(collide, true)
	$ray_2.set_collision_mask_value(collide, true)
