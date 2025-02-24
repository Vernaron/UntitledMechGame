extends Node2D
@onready var navrid := get_world_2d().get_navigation_map()
# Called when the node enters the scene tree for the first time.
@export var enemy : Resource
@export var enemyTypes:Array[WeightedSpawn]
@export var minDistance:int
@onready var max_dist := minDistance*2
var debug_sprite_1 := preload("res://assets/bodies/Bulwark_body_1.png")
var debug_sprite_2 := preload("res://assets/bodies/Strider_body_1.png")
var total_size:float = 0
var active: bool = false
var failed: bool = false
func _ready()->void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	Signals.spawn_primary.connect(_spawn)
	for n in enemyTypes:
		total_size+=n.weight
func _spawn()->void:
	if(active):
		_spawn_enemy()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
	if(failed):
		_spawn_enemy()
func build_enemy_simple(pos:Vector2)->void:
	
	var randnum := randf()*total_size
	var type:ItemData.Loadouts
	var count:int
	var sum :float= 0
	for i in enemyTypes:
		sum+=i.weight
		if randnum<sum:
			type =  i.type
			count = i.number
			break
	for num in range(0, count):
		var basic_enemy :Node2D= enemy.instantiate()
		basic_enemy.set_type(type)
		basic_enemy.construct(
			"Enemy"
		)
		basic_enemy.position = pos + Vector2(50,0).rotated(randf()*2*PI)
		Signals.spawn_root.emit(basic_enemy)	
func _spawn_enemy()->void:
	var n := 0
	failed = true
	var path_found:=false
	#var position_loc = get_viewport().get_visible_rect().size+PlayerInfo.target.global_position
	while(path_found==false&&n<20):
		n+=1
		var distance := minDistance*(1+0.5*randf())
		var angle := 2*PI*randf()
		var attempt_location :=PlayerInfo.target.global_position+Vector2(0, distance).rotated(angle)
		var adjusted_location :=  NavigationServer2D.map_get_closest_point(navrid, attempt_location)
		#var test_1 := Sprite2D.new()
		#var test_2 := Sprite2D.new()
		if(attempt_location.distance_squared_to(adjusted_location)>1):
#			print("Attempt Start:")
#			print(attempt_location)
#			print(adjusted_location)
		#	test_1.texture = debug_sprite_1
		#	test_2.texture = debug_sprite_2
		#	test_1.position = adjusted_location
			attempt_location=adjusted_location+Vector2(400, 0).rotated(attempt_location.angle_to_point(adjusted_location))
#			print(attempt_location)
		#	test_2.position = attempt_location
			
		if(PlayerInfo.target.position.distance_to(attempt_location)<=minDistance):
			continue
		var path := NavigationServer2D.map_get_path(navrid, PlayerInfo.target.position, attempt_location, false)
		var totalLength :float= 0
		var pathMax :float= max_dist*1.5
		for i in range(1, path.size()):
			totalLength+=path[i].distance_to(path[i-1])
			if(totalLength>pathMax):
				break
		
		if(totalLength<pathMax):
			path_found=true
			failed = false
			build_enemy_simple(attempt_location)
		#	Signals.spawn_root.emit(test_1)
		#	Signals.spawn_root.emit(test_2)


func _on_body_entered(_body:Node2D)->void:
	active = true
func _on_body_exited(_body:Node2D)->void:
	active = false
