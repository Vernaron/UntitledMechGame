extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready()->void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
	pass


func _on_drag_ended(_value_changed:bool)->void:
	if(_value_changed):
		PlayerInfo.settings["intensity"] = value/100
		Signals.SettingsChange.emit()
