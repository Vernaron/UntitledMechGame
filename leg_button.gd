extends TextureButton
var wasPressed:bool= false

func _ready() -> void:
	self.pressed.connect(was_pressed)
	Signals.change_inventory_type.connect(toggleoff)
	
func was_pressed():
	wasPressed=true
	Signals.change_inventory_type.emit("Leg")
func toggleoff(_unused):
	if wasPressed:
		button_pressed = true
		wasPressed = false
	else:
		button_pressed = false
