extends Timer


func _on_timeout()->void:
	Signals.spawn_primary.emit()
