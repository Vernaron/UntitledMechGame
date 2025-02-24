extends CollisionPolygon2D

var track_legs : bool = false 
# Called when the node enters the scene tree for the first time.
func set_array(_points:PackedVector2Array)->void:
	polygon = _points
func _physics_process(_delta:float)->void:
	if(!track_legs):
		rotation=get_parent().get_node("Body").rotation
