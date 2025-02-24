extends Legs
@export var drops_loot : bool = true
var valid_targets : Array[Node2D] = []
var curr_type : ItemData.Loadouts = ItemData.Loadouts.Strider
var loot_res := preload("res://scenes/LootCollectable.tscn")
var death_explosion := preload("res://assets/effects/explosion_normal.tscn")
var target : Node2D = null
signal update_health
@onready var navrid := get_world_2d().get_navigation_map()
var currPath: = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]
@export var attention_span : float
@export var swap_time: float
var time_lost_vision:float=0
var time_gained_vision:float = 0
var super_angle := angle
enum pathing{direct=0, nav=1}
var path_type :pathing=pathing.direct
var path_update:int = 0
var navAngle:float = 0
var angleOffset:float = 0
var distOffset : float = 0
var wallOffset : float = 0
@export var move_range:=2000
var angleOffsetCooldown:float = 0
var dropTables := {
	ItemData.Loadouts.Strider:{
		"materialChance" : 0.7,
		"equipmentChance":0.2,
		"materials":{
			"screws":WeightedDrops.new("screws", Vector2(1, 4), .5),
			"plates":WeightedDrops.new("plates", Vector2(2, 5), .5),
			
		},
		"equipment":{
			"autocannon":WeightedDrops.new("weapon_autocannon", Vector2(1, 1), .6),
			"gatling":WeightedDrops.new("weapon_gatling", Vector2(1, 1), .6), 
			"strider_1_body":WeightedDrops.new("body_strider_1", Vector2(1, 1), .2),
			"strider_1_legs":WeightedDrops.new("legs_strider_1",Vector2(1, 1), .2),
		}
		
	}, 
	ItemData.Loadouts.Bulwark:{
		"materialChance" : 0.7,
		"equipmentChance":0.2,
		"materials":{
			"screws":WeightedDrops.new("screws", Vector2(1, 4), .5),
			"plates":WeightedDrops.new("plates", Vector2(2, 5), .5),
			
		},
		"equipment":{
			"bolter":WeightedDrops.new("weapon_bolter", Vector2(1, 2), .6), 
			"strider_1_body":WeightedDrops.new("body_strider_1", Vector2(1, 1), .2),
			"strider_1_legs":WeightedDrops.new("legs_strider_1",Vector2(1, 1), .2),
		}
		
	},
	ItemData.Loadouts.SmallTank:{
		"materialChance" : 0.7,
		"equipmentChance":0.2,
		"materials":{
			"screws":WeightedDrops.new("screws", Vector2(1, 4), .5),
			"plates":WeightedDrops.new("plates", Vector2(2, 5), .5),
			
		},
		"equipment":{
			"gatling":WeightedDrops.new("weapon_tank_cannon", Vector2(1, 2), .6), 
		}
		
	},
	ItemData.Loadouts.SmallHeli:{
		"materialChance" : 0.7,
		"equipmentChance":0.2,
		"materials":{
			"screws":WeightedDrops.new("screws", Vector2(1, 4), .5),
			"plates":WeightedDrops.new("plates", Vector2(2, 5), .5),
			
		},
		"equipment":{
			"gatling":WeightedDrops.new("weapon_gatling", Vector2(1, 2), .6), 
		}
		
	},
	ItemData.Loadouts.Roamer:{
		"materialChance" : 0.7,
		"equipmentChance":0.2,
		"materials":{
			"screws":WeightedDrops.new("screws", Vector2(1, 4), .5),
			"plates":WeightedDrops.new("plates", Vector2(2, 5), .5),
			
		},
		"equipment":{
			"laser_small":WeightedDrops.new("weapon_laser_small", Vector2(1, 1), .6), 
			"roamer_1_body":WeightedDrops.new("body_roamer_1", Vector2(1, 1), .2),
			"roamer_1_legs":WeightedDrops.new("legs_roamer_1",Vector2(1, 1), .2),
		}
	}
	
}
class behaviors:
	var orbit_distance : int = 100 #pixels
	var aggression : int =5
	var target_update : float = .1
	var direction_update_time : float = 3.0
	#states whether the mech orbits its target or 
	#moves between predesignated points
	var picks_points : bool = false
	var has_follow_target : bool = false
var loadout_behaviors := {
	ItemData.Loadouts.Strider:{
		"orbit-distance" : 1,
	},
	ItemData.Loadouts.Bulwark:{
		
	},
	ItemData.Loadouts.SmallTank:{
		
	},
	ItemData.Loadouts.SmallHeli:{
		
	},
	ItemData.Loadouts.Roamer:{
		
	},
}
var totalDrops := []
func _ready_custom()->void:
	pass#	Signals.retarget.connect(setTarget)	
func setTarget()->void:
	if target!=null&&path_type==pathing.nav&&path_update==0&&\
		global_position.distance_to(target.global_position)<move_range\
		&&get_parent().process_mode!=Node.PROCESS_MODE_DISABLED: 
		calc_path()
	path_update=(path_update+1)%3
func calc_path()->void:
	if target!=null:
		currPath = NavigationServer2D.map_get_path(navrid, global_position, target.global_position, false)
		navAngle=currPath[1].angle_to_point(currPath[0])		
	#
func _construct_custom()->void:
	match(curr_type):
		ItemData.Loadouts.Strider:
			set_current_body(ItemData.bodies["strider_1"])
			set_current_legs(ItemData.legs["strider_1"])
			set_weapons_from_array([ItemData.weapons["bolter"],ItemData.weapons["bolter"]])
		ItemData.Loadouts.Bulwark:
			set_current_body(ItemData.bodies["bulwark_1"])
			set_current_legs(ItemData.legs["bulwark_1"])
			set_weapons_from_array([ItemData.weapons["gatling"], ItemData.weapons["autocannon"]])
		ItemData.Loadouts.SmallTank:
			set_current_body(ItemData.bodies["tank_1"])
			set_current_legs(ItemData.legs["tank_1"])
			set_weapons_from_array([ItemData.weapons["tank_cannon"]])
		ItemData.Loadouts.SmallHeli:
			set_current_body(ItemData.bodies["heli_1"])
			set_current_legs(ItemData.legs["heli_1"])
			set_weapons_from_array([ItemData.weapons["gatling"]])
		ItemData.Loadouts.Roamer:
			set_current_body(ItemData.bodies["roamer_1"])
			set_current_legs(ItemData.legs["roamer_1"])
			set_weapons_from_array([ItemData.weapons["laser_small"]])
	update_health.emit()
	
	
func set_type(_type: ItemData.Loadouts)->void:
	curr_type = _type
	_construct_custom()

func _physics_process_custom(delta:float)->void:
	angleOffsetCooldown-=delta
	
	if(angleOffsetCooldown<=0):
		angleOffsetCooldown+=1+randf()*3
		if angleOffset<=0:angleOffset=PI/6+(2*PI/6)*randf()
		else:angleOffset=-PI/6-(2*PI/6)*randf()
	if target!=null:$Body/playerPointer.target_position.y = -target.position.distance_to($Body/playerPointer.global_position)
	if($Body/playerPointer.get_collider()!=null):
		time_lost_vision+=delta
		time_gained_vision=0
	else:
		time_lost_vision=0
		time_gained_vision+=delta
	if(time_lost_vision>swap_time&&path_type==pathing.direct):
		path_type=pathing.nav
		path_update=0
		
	elif time_gained_vision>swap_time&&path_type==pathing.nav:
		path_type=pathing.direct
		
	if(target!=null&&abs(position.distance_to(target.position)) < move_range*2):
		is_moving = true
		if(abs(position.distance_to(target.position)) < move_range/2.0):
			if angleOffset>0:
				distOffset=PI/2
			else:
				distOffset=-PI/2
		
		else:
			distOffset*=.8
	else:
		is_moving = false
func _get_intended_angle()->void:
	var tempAngle:float=0
	#var predictiveoffset:= 0
	
	if(path_type==pathing.direct):
		var direction:= position.direction_to(target.position)
		var farDistMod := 1
		if(position.distance_to(target.position) > move_range/1.5||$collChecker.is_colliding()):
			
			farDistMod = 4
		tempAngle = normalize(atan2(-direction.y, -direction.x) + 
				((angleOffset+distOffset)/farDistMod))
			#$collChecker.rotation=tempAngle 
		tempAngle+=normalize(tempAngle-normalize(angle))/6
		
	elif(path_type==pathing.nav):
		tempAngle=navAngle
	
	#if $collChecker.is_colliding():
	#	predictiveoffset = PI	
	angle = tempAngle
func _take_damage(damage:float, location:Array=[], bullet_spark:=false, laser_spark:=false)->void:
	damage_inflict(damage)
	resolve_particles(location, bullet_spark, laser_spark, damage)
	Signals.screen_shake.emit(damage/2, .2)
	update_health.emit()
func _on_kill()->void:
	if drops_loot:
		roll_drops()
		for n:Array in totalDrops:
			var loot: = loot_res.instantiate()
			print(n)
			loot.setval(n[0], n[1])
			loot.position = global_position
			Signals.spawn_root.emit(loot)
	var temp_explosion := death_explosion.instantiate()
	temp_explosion.position = global_position
	Signals.spawn_root.emit(temp_explosion)
	Signals.screen_shake.emit(5,.2)
	queue_free()
func add_or_append(array_ref:Array, value : String)->void:
	var found := false
	for n:Array in array_ref:
		if n[0]==value:
			n[1]+=1
			found=true
			break
	if !found:
		array_ref.push_back([value, 1])
func roll_drops()->void:
	var drops:Dictionary = dropTables[curr_type]
	for i in range(0, 1+randi()%4):
		var dropType: = randf()
		if(dropType<drops["materialChance"]):
			var totalnum :float=0
			for n:String in drops["materials"]:
				var obj:WeightedDrops = drops["materials"][n]
				totalnum+=obj.chance
			var selector := randf()*totalnum
			var curr_val :float= 0
			for n:String in drops["materials"]:
				var obj :WeightedDrops= drops["materials"][n]
				curr_val+=obj.chance
				if curr_val>=selector:
					totalDrops.push_back([obj.name, obj.get_random_amount()])
					break
		elif(dropType<drops["materialChance"]+drops["equipmentChance"]):
			var totalnum :=0
			for n:String in drops["equipment"]:
				totalnum+=drops["equipment"][n].chance
			var selector := randf()*totalnum
			var curr_val :float= 0
			for n:String in drops["equipment"]:
				var obj :WeightedDrops= drops["equipment"][n]
				curr_val+=obj.chance
				if curr_val>=selector:
					totalDrops.push_back([obj.name, obj.get_random_amount()])
					break
	


func _on_target_detector_body_entered(body: Node2D) -> void:
	valid_targets.push_back(body)


func _on_target_detector_body_exited(body: Node2D) -> void:
	valid_targets.erase(body)


func _on_pick_target_timeout() -> void:
	var temp_target : Node2D = null
	var min_dist : float = -1
	for n in valid_targets:
		if min_dist>0&&min_dist>global_position.distance_squared_to(n.global_position):
			temp_target = n
			min_dist = global_position.distance_squared_to(n.global_position)
		else:
			temp_target = n
			min_dist = global_position.distance_squared_to(n.global_position)
	target = temp_target
	
