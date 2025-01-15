extends Area2D
var type: String = ""
var number : int = 0
var velocity : Vector2 = Vector2.ZERO
var collecting : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(0, 400).rotated(2*PI*randf()) * (.7+.3*randf())
func setval(_type, _number):
	type = _type
	number = _number
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position+=velocity*delta
	if collecting : 
		pass
	else: 
		velocity*=.8



func _on_body_entered(body: Node2D) -> void:
	velocity = Vector2.ZERO


func _on_area_entered(area: Area2D) -> void:
	collecting = true
	velocity = Vector2(0, 500).rotated(PI+position.angle_to_point(PlayerInfo.target.position))
