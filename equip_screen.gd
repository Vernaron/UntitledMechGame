extends Panel
var current_type = "Body"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_images()
	Signals.change_inventory_type.connect(change_inventory_type)
func change_inventory_type(newType : String):
	update_images()
	match(newType):
		"Weapon_1":
			pass
		"Weapon_2":
			pass
		"Weapon_3":
			pass
		"Weapon_4":
			pass
		"Weapon_5":
			pass
		"Body":
			$Details/Visual/Object.sprite_frames = ItemData.bodies[PlayerInfo.active_save_data["active_body"]].sprite
		"Leg":
			$Details/Visual/Object.sprite_frames = ItemData.legs[PlayerInfo.active_save_data["active_legs"]].sprite
func update_images():
#	print(PlayerInfo.active_save_data["active_body"])
	$Body/Body_Sprite.sprite_frames = ItemData.bodies[PlayerInfo.active_save_data["active_body"]].sprite
	$Legs/Leg_Sprite.sprite_frames = ItemData.legs[PlayerInfo.active_save_data["active_legs"]].sprite
#	update_details()
#func update_details():
#	$Details/Visual/Object.sprite_frames = ItemData.bodies[PlayerInfo.active_save_data["active_body"]].sprite
	
