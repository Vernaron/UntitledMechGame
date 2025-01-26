extends Panel
var current_type : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Signals.update_details_screen.connect(update_details)
	#Signals.change_inventory_type.connect(set_index_dictionary)
	pass

func update_details(obj:String):
	$Stats.text = ItemData.get_description(obj, current_type)
	$Visual/Object.sprite_frames = ItemData.get_image(obj, current_type)
func set_index_dictionary(obj: String):
	if obj.find("Weapon")!=-1:
		current_type = "Weapon"
	else:
		current_type = obj
