extends Legs

func _ready_custom()->void:
	Signals.teleport_player.connect(teleport)
func teleport(location:Vector2)->void:
	global_position = location
func _process_custom(_delta:float)->void:
	if(Input.is_action_pressed("up")||Input.is_action_pressed("down")
	   || Input.is_action_pressed("left")||Input.is_action_pressed("right")):
		is_moving = true
		
	else:
		is_moving = false
	if(Input.is_action_just_pressed("special")):
		start_dash()
	elif(Input.is_action_just_released("special")):
		end_dash()

func _get_intended_angle()->void: 
	angle = atan2(Input.get_axis("down", "up"),-Input.get_axis("left","right"))
func _take_damage(_damage:float, location:Array=[], bullet_spark:=false, laser_spark:=false)->void:
	resolve_particles(location, bullet_spark, laser_spark, _damage)
func _construct_custom()->void:
	set_current_legs(PlayerInfo.get_active_legs())
	set_current_body(PlayerInfo.get_active_body())
	set_weapons_from_array(PlayerInfo.get_active_weapons())
