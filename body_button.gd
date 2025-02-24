extends TextureButton
var wasPressed:bool= false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(was_pressed)
	Signals.change_inventory_type.connect(toggleoff)
	
func was_pressed()->void:
	wasPressed=true
	Signals.change_inventory_type.emit("Body")
func toggleoff(_unused:bool)->void:
	if wasPressed:
		button_pressed = true
		wasPressed = false
	else:
		button_pressed = false
