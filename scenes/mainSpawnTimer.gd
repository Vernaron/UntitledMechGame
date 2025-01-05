extends Timer


func _on_timeout():
	Signals.spawn_primary.emit()
