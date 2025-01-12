extends TextureButton
var wasPressed:bool= false
@export var number : int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(was_pressed)
	Signals.change_inventory_type.connect(toggleoff)
	
func was_pressed():
	wasPressed=true
	Signals.change_inventory_type.emit("Weapon_"+str(number))
func toggleoff(_unused):
	if wasPressed:
		button_pressed = true
		wasPressed = false
	else:
		button_pressed = false
