extends TextureButton
var wasPressed:bool= false
@export var number : int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(was_pressed)
	Signals.change_inventory_type.connect(toggleoff)
	get_parent().get_parent().body_changed.connect(update_lines)
	update_lines()
	
func was_pressed()->void:
	wasPressed=true
	Signals.change_inventory_type.emit("Weapon_"+str(number))
func toggleoff(_unused:bool)->void:
	if wasPressed:
		button_pressed = true
		wasPressed = false
	else:
		button_pressed = false
func update_lines()->void:
	var current_body :Dictionary= ItemData.bodies[PlayerInfo.active_save_data["active_body"]]
	if current_body["hardpoints"][number-1][1]==-1:
		visible=false
		disabled=true
		erase_line()
	else:
		visible=true
		disabled=false
		
		redraw_line()
func redraw_line()->void:
	$Line.clear_points()
	var current_body :Dictionary= ItemData.bodies[PlayerInfo.active_save_data["active_body"]]
	var location : Vector2 = current_body["hardpoints"][number-1][0]
	$Line.add_point(Vector2(32, 32))
	$Line.add_point(location*.45+(get_parent().global_position-global_position)/1.8+pivot_offset/.6)
func erase_line()->void:
	$Line.clear_points()	
	
