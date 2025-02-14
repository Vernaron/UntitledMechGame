extends GPUParticles2D
var scaleFactor = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	$subExplosion.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scaleFactor = min(scaleFactor+(3.0 - scaleFactor)*delta*3,3.0)
	$pulse.scale.x = scaleFactor
	$pulse.scale.y = scaleFactor
	$pulse.self_modulate.a=(3-scaleFactor)/3
	if scaleFactor>=2.999:
		queue_free()
