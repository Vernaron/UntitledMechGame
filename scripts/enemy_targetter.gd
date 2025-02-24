extends Timer




func _on_timeout()->void:
	Signals.retarget.emit()
