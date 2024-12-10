extends Node2D
class_name Damage_Dealer
enum Team{Enemy, Ally, Both}
var team : int
@export var DAMAGE = 1
var origin = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	origin = global_position
	_ready_custom()
func set_team(_team : int):
	team = _team
	if team == 0||team==2:
		_set_collide(3, true)
	if team == 1||team==2:
		_set_collide(1, true)
	_team_set()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func deal_damage(target, angle=null, bullet_spark=false, laser_spark=false):
	target._take_damage(DAMAGE, angle, bullet_spark, laser_spark)
func _set_collide(number : int,is_colliding : bool):
	pass
func _ready_custom():
	pass
func _team_set():
	pass
