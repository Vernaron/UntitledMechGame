extends Damage_Dealer
class_name Bullet

@export var SPEED = 10000.0
var height_mod
func _ready_custom():
	var target_hit = get_world_2d().direct_space_state.\
		intersect_ray(PhysicsRayQueryParameters2D.\
		create(global_position, global_position+Vector2(0, -10000).rotated(rotation)))
	height_mod = Vector2(0, -$Sprite2D.texture.get_height()).rotated(global_rotation) * $Sprite2D.scale.x
	if(target_hit!={}):
		final_position =target_hit.position
		if(target_hit.collider is Legs && target_hit.collider.get_collision_layer_value(target)==true):
			enemy_coll = target_hit.collider
			if(enemy_coll!= null):deal_damage(DAMAGE, enemy_coll, [rotation-PI/2,final_position], true)
	else:
		final_position = global_position+Vector2(0, -10000).rotated(rotation)	
		
func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(rotation)
	if enemy_coll!=null:final_position=enemy_coll.global_position
	if((velocity*delta).dot(final_position - (global_position+velocity*delta+height_mod*2))<0):
			
			queue_free()
	position+=velocity*delta
	
func _set_collide(collide : int, _is_colliding: bool):
	target = collide
func rotation_fixed(rot):
	var temp = rot
	if temp < 0: return temp + 2*PI
	return temp 
	
	
