extends Area2D
var type: String = ""
var number : int = 0
var velocity : Vector2 = Vector2.ZERO
var collecting : bool = false
var acceleration = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(0, 4000).rotated(2*PI*randf()) * (.7+.3*randf())
func setval(_type, _number):
	type = _type
	number = _number
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position+=velocity*delta
	if collecting : 
		velocity=(Vector2(0, 500).rotated(-PI/2+global_position.angle_to_point(PlayerInfo.target.global_position))) * acceleration
		acceleration+=delta*5
		if(global_position.distance_to(PlayerInfo.target.global_position)<25):
			PlayerInfo.collect_drop(type, number)
			queue_free()
	else: 
		velocity*=0.9



func _on_body_entered(body: Node2D) -> void:
	if(!collecting):
		velocity = Vector2.ZERO


func _on_area_entered(area: Area2D) -> void:
	if(!collecting):
		collecting = true
		set_collision_mask_value(20, false)
