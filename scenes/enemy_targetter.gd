extends Timer




func _on_timeout():
	Signals.retarget.emit(PlayerInfo.target.position)
