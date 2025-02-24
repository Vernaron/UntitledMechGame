extends LightOccluder2D

# Called when the node enters the scene tree for the first time.
func set_array(_points:PackedVector2Array)->void:
	material.polygon = _points
func _physics_process(_delta:float)->void:
	rotation=get_parent().get_node("Body").rotation
