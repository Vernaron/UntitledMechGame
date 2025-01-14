extends Panel
var current_type : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.update_details_screen.connect(update_details)
	Signals.change_inventory_type.connect(set_index_dictionary)

func update_details(obj:String):
	match(current_type):
		"Leg":
			$Stats.text = ItemData.leg_descriptions[obj]
			$Visual/Object.sprite_frames = ItemData.legs[obj].sprite
		"Body":
			$Stats.text = ItemData.body_descriptions[obj]
			$Visual/Object.sprite_frames = ItemData.bodies[obj].sprite
		"Weapon":
			$Stats.text = ItemData.weapon_descriptions[obj][0]
			$Visual/Object.sprite_frames = null
func set_index_dictionary(obj: String):
	if obj.find("Weapon")!=-1:
		current_type = "Weapon"
	else:
		current_type = obj
