extends Node2D
@onready var navrid = get_world_2d().get_navigation_map()
# Called when the node enters the scene tree for the first time.
@export var enemy : Resource
@export var enemyTypes:Array[ItemData.Basic_Enemy]
@export var minDistance:int
@onready var max_dist = minDistance*2
var active: bool = false
var failed: bool = false
func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	Signals.spawn_primary.connect(_spawn)
func _spawn():
	if(active):
		_spawn_enemy()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(failed):
		_spawn_enemy()
func build_enemy_simple(pos):
	var basic_enemy = enemy.instantiate()
	basic_enemy.set_type(enemyTypes[randi()%enemyTypes.size()])
	basic_enemy.construct(
		"Enemy"
	)
	basic_enemy.position = pos
	Signals.spawn_root.emit(basic_enemy)	
func _spawn_enemy():
	var n = 0
	failed = true
	var path_found=false
	#var position_loc = get_viewport().get_visible_rect().size+PlayerInfo.target.global_position
	while(path_found==false&&n<20):
		n+=1
		var distance = minDistance*(1+0.5*randf())
		var angle = 2*PI*randf()
		var attempt_location =PlayerInfo.target.global_position+Vector2(0, distance).rotated(angle)
		var adjusted_location =  NavigationServer2D.map_get_closest_point(navrid, attempt_location)
		if(attempt_location!=adjusted_location):
			attempt_location=adjusted_location+Vector2(0, 0).rotated(attempt_location.angle_to_point(adjusted_location))
		if(PlayerInfo.target.position.distance_to(attempt_location)<=minDistance):
			continue
		var path = NavigationServer2D.map_get_path(navrid, PlayerInfo.target.position, attempt_location, false)
		var totalLength = 0
		var pathMax = max_dist*1.5
		for i in range(1, path.size()):
			totalLength+=path[i].distance_to(path[i-1])
			if(totalLength>pathMax):
				break
		
		if(totalLength<pathMax):
			path_found=true
			failed = false
			build_enemy_simple(attempt_location)


func _on_body_entered(_body):
	active = true
func _on_body_exited(_body):
	active = false
