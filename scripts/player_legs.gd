extends Legs


func _process_custom(_delta):
	if(Input.is_action_pressed("up")||Input.is_action_pressed("down")
	   || Input.is_action_pressed("left")||Input.is_action_pressed("right")):
		is_moving = true
		
	else:
		is_moving = false
	if(Input.is_action_just_pressed("special")):
		start_dash()
	elif(Input.is_action_just_released("special")):
		end_dash()

func _get_intended_angle(): 
	angle = atan2(Input.get_axis("down", "up"),-Input.get_axis("left","right"))
	
func _construct_custom():
	set_current_legs(PlayerInfo.active["legs"])
	set_current_body(PlayerInfo.active["body"])
	set_weapons_from_array(PlayerInfo.active["weapons"])
