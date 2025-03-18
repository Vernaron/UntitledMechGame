extends GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	emitting=true # Replace with function body.

func set_damage(damage:float)->void:
	amount = PlayerInfo.settings["particles"] * 2 * (5+damage)/5
	process_material.spread = 45 * 10/(10+damage) 
	process_material.initial_velocity_min = 2000 * (20+damage)/20 
	process_material.initial_velocity_max = process_material.initial_velocity_min * 1.5
	process_material.scale_min =PlayerInfo.settings["particles"] * 4 * (10 + damage)/10 
	process_material.scale_max = process_material.scale_min * 1.4
	process_material.damping_max = process_material.initial_velocity_min 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
	if(!emitting):
		queue_free()
