extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_legs_update_health() -> void:
	max_value = get_parent().get_parent().health
	value = get_parent().get_parent().current_health
