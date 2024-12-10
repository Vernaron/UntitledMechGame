extends Damage_Dealer
class_name Bullet

@export var SPEED = 10000.0
var velocity : Vector2
var final_position : Vector2 = Vector2.ZERO
var target : int
var enemy_coll
func _ready_custom():
	var target_hit = get_world_2d().direct_space_state.\
		intersect_ray(PhysicsRayQueryParameters2D.\
		create(global_position, global_position+Vector2(0, -10000).rotated(rotation)))
	if(target_hit!={}):
		final_position =target_hit.position# target_hit.collider.global_position
		if(target_hit.collider is Legs && target_hit.collider.get_collision_layer_value(target)==true):
			enemy_coll = target_hit.collider
	else:
		final_position = global_position+Vector2(0, -10000).rotated(rotation)	
		
func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(rotation)
	if((velocity*delta).dot(final_position - (global_position++velocity*delta))<0):
			if(enemy_coll!= null):deal_damage(enemy_coll, [rotation-PI/2,final_position], true)
			queue_free()
	position+=velocity*delta
	
	#if(abs(global_position.distance_to(origin)) > 10000):
#		print("AUUUH")
#		queue_free()	
func _set_collide(collide : int, is_colliding: bool):
	target = collide
func rotation_fixed(rot):
	var temp = rot
	if temp < 0: return temp + 2*PI
	return temp 
	
	
