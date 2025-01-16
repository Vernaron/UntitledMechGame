extends Node2D
class_name Damage_Dealer
enum Team{Enemy, Ally, Both}
var team : int
@export var DAMAGE = 1
var velocity : Vector2
var final_position : Vector2 = Vector2.ZERO
var target : int
var enemy_coll
var aoe : float
var origin = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	origin = global_position
	
	_ready_custom()
	visible = true
func set_team(_team : int):
	team = _team
	if team == 0||team==2:
		print("There")
		_set_collide(3, true)
	if team == 1||team==2:
		print("Here")
		_set_collide(1, true)
	_team_set()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func deal_damage(_damage, _target, location=null, bullet_spark=false, laser_spark=false):
	_target._take_damage(_damage , location, bullet_spark, laser_spark)
func _set_collide(_number : int,_is_colliding : bool):
	pass
func _ready_custom():
	pass
func _team_set():
	pass
