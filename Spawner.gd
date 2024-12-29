extends Node2D
@onready var navrid = get_world_2d().get_navigation_map()
@onready var max_dist = get_viewport().get_visible_rect().size.length()*2
# Called when the node enters the scene tree for the first time.
@export var enemy : Array[Node2D]
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("debug")):
		var n = 0
		var path_found=false
		var position_loc = get_viewport().get_visible_rect().size+PlayerInfo.target.global_position
		while(path_found==false&&n<20):
			n+=1
			var distance = get_viewport().get_visible_rect().size.length()*(1+0.5*randf())
			var angle = 2*PI*randf()
			var attempt_location = PlayerInfo.target.global_position+Vector2(0, distance).rotated(angle)
			print("attempt_loc",attempt_location)
			var path = NavigationServer2D.map_get_path(navrid, PlayerInfo.target.position, attempt_location, false)
			var totalLength = 0
			for i in range(1, path.size()):
				totalLength+=path[i].distance_to(path[i-1])
				if(totalLength>max_dist):
					print("Too Far")
					break
			
			if(totalLength<max_dist):
				print(path)
				print(totalLength)
				print(max_dist)
				path_found=true
				print("Found!")
func build_enemy_simple():
	var basic_enemy = enemy[randi()%enemy.size()].instantiate()
	basic_enemy.set_type(ItemData.Basic_Enemy.Strider)
	basic_enemy.construct(
		"Enemy", $mainCamera, self
	)
	basic_enemy.position = Vector2(1000, 10)
	add_child(basic_enemy)	
