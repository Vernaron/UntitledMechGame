extends Legs
var curr_type : ItemData.Basic_Enemy = ItemData.Basic_Enemy.Strider
var loot_res = preload("res://scenes/LootCollectable.tscn")
var target : Vector2 = Vector2.ZERO
@onready var navrid = get_world_2d().get_navigation_map()
var currPath = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]
@export var attention_span : float
@export var swap_time: float
var time_lost_vision:float=0
var time_gained_vision:float = 0
var super_angle = angle
enum pathing{direct=0, nav=1}
var path_type :pathing=pathing.direct
var path_update:int = 0
var navAngle:float = 0
var angleOffset:float = 0
var distOffset : float = 0
var wallOffset : float = 0
@export var move_range=2000
var angleOffsetCooldown:float = 0
var dropTables = {
	ItemData.Basic_Enemy.Strider:{
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
	ItemData.Basic_Enemy.Bulwark:{
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
	ItemData.Basic_Enemy.SmallTank:{
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
	ItemData.Basic_Enemy.SmallHeli:{
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
	ItemData.Basic_Enemy.Roamer:{
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
var totalDrops = []
func _ready_custom():
	Signals.retarget.connect(setTarget)	
func  setTarget(_target):
	target = _target
	if path_type==pathing.nav&&path_update==0&&global_position.distance_to(target)<move_range\
		&&get_parent().process_mode!=Node.PROCESS_MODE_DISABLED: 
		calc_path()
	path_update=(path_update+1)%3
func calc_path():
	currPath = NavigationServer2D.map_get_path(navrid, global_position, target, false)
	navAngle=currPath[1].angle_to_point(currPath[0])		
	#
func _construct_custom():
	match(curr_type):
		ItemData.Basic_Enemy.Strider:
			set_current_body(ItemData.bodies["strider_1"])
			set_current_legs(ItemData.legs["strider_1"])
			set_weapons_from_array([ItemData.weapons["bolter"],ItemData.weapons["bolter"]])
		ItemData.Basic_Enemy.Bulwark:
			set_current_body(ItemData.bodies["bulwark_1"])
			set_current_legs(ItemData.legs["bulwark_1"])
			set_weapons_from_array([ItemData.weapons["gatling"], ItemData.weapons["autocannon"]])
		ItemData.Basic_Enemy.SmallTank:
			set_current_body(ItemData.bodies["tank_1"])
			set_current_legs(ItemData.legs["tank_1"])
			set_weapons_from_array([ItemData.weapons["tank_cannon"]])
		ItemData.Basic_Enemy.SmallHeli:
			set_current_body(ItemData.bodies["heli_1"])
			set_current_legs(ItemData.legs["heli_1"])
			set_weapons_from_array([ItemData.weapons["gatling"]])
		ItemData.Basic_Enemy.Roamer:
			set_current_body(ItemData.bodies["roamer_1"])
			set_current_legs(ItemData.legs["roamer_1"])
			set_weapons_from_array([ItemData.weapons["laser_small"]])
	
	
func set_type(_type: ItemData.Basic_Enemy):
	curr_type = _type
	_construct_custom()

func _physics_process_custom(delta):
	angleOffsetCooldown-=delta
	if(angleOffsetCooldown<=0):
		angleOffsetCooldown+=1+randf()*3
		if angleOffset<=0:angleOffset=PI/6+(2*PI/6)*randf()
		else:angleOffset=-PI/6-(2*PI/6)*randf()
	$Body/playerPointer.target_position.y = -target.distance_to($Body/playerPointer.global_position)
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
		
	if(abs(position.distance_to(target)) < move_range*2):
		is_moving = true
		if(abs(position.distance_to(target)) < move_range/2.0):
			if angleOffset>0:
				distOffset=PI/2
			else:
				distOffset=-PI/2
		
		else:
			distOffset*=.8
		if(touching_wall):
			if angleOffset>0:
				wallOffset=-PI/2
			else:
				wallOffset=PI/2
		else:
			wallOffset*=0.8
		
	else:
		is_moving = false
func _get_intended_angle():
	var tempAngle=0
	
	if(path_type==pathing.direct):
		var direction= position.direction_to(target)
		if(position.distance_to(target) > move_range/1.5):
			tempAngle = normalize(atan2(-direction.y, -direction.x) + (angleOffset/2)+distOffset+wallOffset)
		else:
			tempAngle = normalize(atan2(-direction.y, -direction.x) + angleOffset+distOffset+wallOffset)
		tempAngle+=normalize(tempAngle-normalize(angle))/6
	elif(path_type==pathing.nav):
		tempAngle=navAngle
	angle = tempAngle
func _take_damage(damage, location=null, bullet_spark=false, laser_spark=false):
	damage_inflict(damage)
	resolve_particles(location, bullet_spark, laser_spark, damage)
	Signals.screen_shake.emit(damage/2, .2)
func _on_kill():
	roll_drops()
	print(totalDrops)
	for n in totalDrops:
		var loot = loot_res.instantiate()
		loot.setval(n[0], n[1])
		loot.position = global_position
		Signals.spawn_root.emit(loot)
	queue_free()
func add_or_append(array_ref:Array, value : String):
	var found = false
	for n in array_ref:
		if n[0]==value:
			n[1]+=1
			found=true
			break
	if !found:
		array_ref.push_back([value, 1])
func roll_drops():
	var drops = dropTables[curr_type]
	print("predrop")
	print(totalDrops)
	for i in range(0, 1+randi()%4):
		print("drop")
		var dropType = randf()
		if(dropType<drops["materialChance"]):
			var totalnum =0
			for n in drops["materials"]:
				var obj = drops["materials"][n]
				totalnum+=obj.chance
			var selector = randf()*totalnum
			var curr_val = 0
			for n in drops["materials"]:
				var obj = drops["materials"][n]
				curr_val+=obj.chance
				if curr_val>=selector:
					totalDrops.push_back([obj.name, obj.get_random_amount()])
					break
		elif(dropType<drops["materialChance"]+drops["equipmentChance"]):
			var totalnum =0
			for n in drops["equipment"]:
				totalnum+=drops["equipment"][n].chance
			var selector = randf()*totalnum
			var curr_val = 0
			for n in drops["equipment"]:
				var obj = drops["equipment"][n]
				curr_val+=obj.chance
				if curr_val>=selector:
					totalDrops.push_back([obj.name, obj.get_random_amount()])
					break
	print(totalDrops)
