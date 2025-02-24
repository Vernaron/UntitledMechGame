extends Area2D
@export var teleportPoint : Node2D


func _on_body_entered(_body:Node2D)->void:
	Signals.ascend.emit(teleportPoint.global_position)


func _on_body_exited(_body:Node2D)->void:
	Signals.stair_exited.emit()
