extends Button
@export var Location : Arena.localeNames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(onPress)
func onPress():
	Signals.start_combat_area.emit(Location)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
