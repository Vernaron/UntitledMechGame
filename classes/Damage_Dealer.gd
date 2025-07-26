extends Node2D
class_name Damage_Dealer
enum Team{Enemy, Ally, Both}
var team : int
@export var DAMAGE :float= 1

var velocity : Vector2
var final_position : Vector2 = Vector2.ZERO
var target : int
var enemy_coll : Object
var heat_hit : float
var aoe : float
var origin := Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready()->void:
	origin = global_position
	
	_ready_custom()
	visible = true
func set_team(_team : int)->void:
	team = _team
	if team == 0||team==2:
		_set_collide(3, true)
	if team == 1||team==2:
		_set_collide(1, true)
	_team_set()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
	pass
func deal_damage(_damage:float, heat : float,_target:Node2D, location:Array, bullet_spark:=false, laser_spark:=false)->void:
	_target._take_damage(_damage ,heat, location, bullet_spark, laser_spark)
func _set_collide(_number : int,_is_colliding : bool)->void:
	pass
func _ready_custom()->void:
	pass
func _team_set()->void:
	pass
