extends Area2D

@export var teleportPoint : Node2D


func _on_body_entered(_body):
	Signals.descend.emit(teleportPoint.global_position)


func _on_body_exited(_body):
	Signals.stair_exited.emit()
