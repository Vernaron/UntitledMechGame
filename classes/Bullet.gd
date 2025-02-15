extends Damage_Dealer
class_name Bullet

@export var SPEED = 10000.0
var height_mod
	
		
func _physics_process(delta):
	if($ray.is_colliding()):
		var currCollision =$ray.get_collider()
		if currCollision is Legs:
			_hit(DAMAGE, currCollision, [rotation-PI/2,$ray.get_collision_point()], true)
			_delete()
		if currCollision is TileMapLayer:
			_delete()
	velocity = Vector2(0, -SPEED).rotated(rotation)
	if enemy_coll!=null:final_position=enemy_coll.global_position		
	position+=velocity*delta
	
func _set_collide(collide : int, _is_colliding: bool):
	$ray.set_collision_mask_value(collide, true)
func rotation_fixed(rot):
	var temp = rot
	if temp < 0: return temp + 2*PI
	return temp 
func _hit(damage, currCollision, _transform, sparks):
	deal_damage(damage, currCollision,_transform,sparks)
func _delete():
	queue_free()
