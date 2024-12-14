extends LightOccluder2D

# Called when the node enters the scene tree for the first time.
func set_array(_points):
	material.polygon = _points
func _physics_process(delta):
	rotation=get_parent().get_node("Body").rotation

