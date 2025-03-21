extends Area2D
@export var startColor : Color
@export var endColor : Color
var updating : bool = false
var target_body : Node2D
func _on_body_entered(body: Node2D) -> void:
	updating = true
	target_body = body


func _on_body_exited(body: Node2D) -> void:
	updating = false
	
	if ( target_body.position.distance_squared_to($start.position))> \
		target_body.position.distance_squared_to($end.position):
		Signals.change_layer_background_color.emit(endColor)
	else: 
		Signals.change_layer_background_color.emit(startColor)
	target_body = null
func _process(delta: float) -> void:
	if(updating):
		var finalColor : Color
		var startDistance : float = target_body.position.distance_squared_to($start.position)
		var endDistance : float = target_body.position.distance_squared_to($end.position)
		var startAngle : float = target_body.position.angle_to_point($start.position)
		var endAngle : float = target_body.position.angle_to_point($end.position)
		if(abs(startAngle-endAngle)<=0.4):
			if startDistance > endDistance:
				finalColor = endColor
			else:
				finalColor = startColor
		else:
			var totalDistance: = endDistance+startDistance
			finalColor = \
				endColor*(startDistance/totalDistance)\
				+ startColor*(endDistance/totalDistance)
		Signals.change_layer_background_color.emit(finalColor)
