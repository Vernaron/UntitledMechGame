extends Resource
class_name WeightedDrops
var name : String = ""
var range : Vector2 = Vector2.ZERO
var chance : float = 0.0
func _init(_name, _range, _chance):
	name = _name
	range = _range
	chance = _chance
func get_random_amount()->int:
	return ceili(range[0]+randf()*(range[1]-range[0]))
