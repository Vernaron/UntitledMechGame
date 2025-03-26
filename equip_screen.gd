extends Panel
var current_type := "Body"
@warning_ignore("unused_signal") signal body_changed()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_images()
	Signals.change_inventory_type.connect(change_inventory_type)
func change_inventory_type(newType : String)->void:
	update_images()
	match(newType):
		"Weapon_1","Weapon_2","Weapon_3","Weapon_4","Weapon_5":
			resolve_hardpoint_size(newType[newType.length()-1].to_int()-1)	
		"Body":
			$SelectedName.text = "[center] Mech Body [/center]"
			$Details/Visual/Object.sprite_frames = ItemData.bodies[PlayerInfo.active_save_data["active_body"]].sprite
		"Leg":
			$SelectedName.text = "[center] Mech Legs [/center]"
			$Details/Visual/Object.sprite_frames = ItemData.legs[PlayerInfo.active_save_data["active_legs"]].sprite
func resolve_hardpoint_size(number:int)->void:
	#var h_size :int= ItemData.bodies[PlayerInfo.active_save_data["active_body"]].hardpoints[number][1]
	var size_class := ""
	#match(h_size):
	#	1: size_class = "S"
	#	2: size_class = "M"
	#	3: size_class = "L"
	#	4: size_class = "XL"
	#	5: size_class = "XXL"
	#print(h_size)
	$SelectedName.text = "[center] "+size_class + " Hardpoint [/center]"
func update_images()->void:

	$Body/Body_Sprite.sprite_frames = ItemData.bodies[PlayerInfo.active_save_data["active_body"]].sprite
	$Legs/Leg_Sprite.sprite_frames = ItemData.legs[PlayerInfo.active_save_data["active_legs"]].sprite
