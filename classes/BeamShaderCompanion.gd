extends ColorRect
var delta_accum = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	material.set_shader_parameter("size_px",size)


func _on_resized():
	material.set_shader_parameter("size_px",size)
	
func set_length(leng):
	size.x = leng
	material.set_shader_parameter("size_px",size)
