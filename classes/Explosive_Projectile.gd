extends Bullet
class_name Explosive
@export var explosion_fx : PackedScene
@export var explosive_targets : Array[Node2D] = []
func _ready_custom()->void:
	$Explosion/coll.shape.radius = aoe
	$Explosion.body_entered.connect(coll_enter)
	$Explosion.body_exited.connect(coll_exit)
func _hit(damage:float, _currCollision:Node2D, _transform:Array, _sparks:bool)->void:
	for n in explosive_targets:
		deal_damage(damage, heat_hit, n,_transform,false)
func _set_collide(collide : int, _is_colliding: bool)->void:
	$ray.set_collision_mask_value(collide, true)
	$Explosion.set_collision_mask_value(collide, _is_colliding)
func coll_enter(body:Node2D)->void:
	explosive_targets.push_back(body)
func coll_exit(body:Node2D)->void:
	explosive_targets.erase(body)
func _delete()->void:
	var explode: =explosion_fx.instantiate()
	explode.scale.x = aoe/175
	explode.scale.y = aoe/175
	explode.position = global_position
	Signals.spawn_root.emit(explode)
	queue_free()
