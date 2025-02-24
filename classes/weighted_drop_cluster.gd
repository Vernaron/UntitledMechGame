extends Resource
class_name WeightedDrops
var name : String = ""
var drop_range : Vector2 = Vector2.ZERO
var chance : float = 0.0
func _init(_name:String, _range:Vector2, _chance:float)->void:
	name = _name
	drop_range = _range
	chance = _chance
func get_random_amount()->int:
	return ceili(drop_range[0]+randf()*(drop_range[1]-drop_range[0]))
