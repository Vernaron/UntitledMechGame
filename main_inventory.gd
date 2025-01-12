extends ItemList
var under_array :Array[String]= []
func _ready():
	Signals.change_inventory_type.connect(update_list)
func update_list(item:String):
	clear()
	under_array = []
	if(item.find("Weapon")!=-1):
		for i in PlayerInfo.active_save_data["owned_weapons"]:
			add_item(ItemData.weapon_descriptions[i[0]][1]+" x"+ str(i[1]))
			under_array.push_back(i[0])
		for i in PlayerInfo.active_save_data["active_weapons"]:
			if i!="":
				add_item(ItemData.weapon_descriptions[i][1]+ "   (Equipped)", null, false)
				under_array.push_back(i)
	elif(item=="Body"):
		for i in PlayerInfo.active_save_data["owned_bodies"]:
			add_item(ItemData.legs[i[0]].name+" x"+ str(i[1]))
			under_array.push_back(i[0])
		add_item(ItemData.bodies[PlayerInfo.active_save_data["active_body"]].name+ "   (Equipped)", null, false)
		under_array.push_back(PlayerInfo.active_save_data["active_body"])
	else:
		for i in PlayerInfo.active_save_data["owned_legs"]:
			add_item(ItemData.legs[i[0]].name+" x"+ str(i[1]))
			under_array.push_back(i[0])
		add_item(ItemData.legs[PlayerInfo.active_save_data["active_legs"]].name+ "   (Equipped)", null, false)
		under_array.push_back(PlayerInfo.active_save_data["active_legs"])

func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	Signals.update_details_screen.emit(under_array[index])
