extends CharacterBody2D


@export var SPEED = 500.0
@export var ACCELERATION = 0.5
var angle = 0 
var curr_move_ratio = 0
var curr_dash_ratio = 0
var turn_vec = Vector2.ZERO
var angle_locked = 0
@export var dash_time = 0.0
@export var dash_cooldown = 0.0
var current_dash_cooldown = 0
var current_dash_time = 0
func _process(delta):

	if(Input.is_action_just_pressed("special")&& current_dash_cooldown<=0):
		curr_dash_ratio = 1*ACCELERATION
		angle_locked = angle
		current_dash_time = dash_time
		current_dash_cooldown = dash_cooldown
		
		
func _physics_process(delta):
	if(Input.is_action_pressed("up")||Input.is_action_pressed("down")
	   || Input.is_action_pressed("left")||Input.is_action_pressed("right")):
		get_turn_vec()
		angle = atan2(turn_vec.x, turn_vec.y)
		curr_move_ratio=min(1.0, curr_move_ratio+ACCELERATION)
	turn()
	velocity = (Vector2(0,-curr_move_ratio*1).rotated(rotation)+
		Vector2(0, -curr_dash_ratio*10).rotated(angle_locked)) * SPEED
	curr_move_ratio*=(1-ACCELERATION)/5
	if(current_dash_time > 0):
		current_dash_time-=delta
	else:
		curr_dash_ratio*=0.8
	move_and_slide()
	if (current_dash_cooldown > 0):
		current_dash_cooldown-=delta;
	
func get_turn_vec():
	turn_vec = Vector2.ZERO
	if (Input.is_action_pressed("up")):
		turn_vec.y+=1
	if (Input.is_action_pressed("down")):
		turn_vec.y-=1
	if (Input.is_action_pressed("left")):
		turn_vec.x-=1			
	if (Input.is_action_pressed("right")):
		turn_vec.x+=1
	
func turn():
	var diff = angle - rotation
	if(diff > PI): diff-=2*PI
	if(diff < -PI): diff+=2*PI
	rotate(diff/(20/ACCELERATION))
