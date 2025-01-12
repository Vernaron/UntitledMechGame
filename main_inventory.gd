extends ItemList
var under_array :Array[Array]= []
var curindex : int = 0
func _ready():
	Signals.change_inventory_type.connect(update_list)
func update_list(item:String):
	clear()
	curindex = -1
	under_array = []
	if(item.find("Weapon")!=-1):
		for i in PlayerInfo.active_save_data["owned_weapons"]:
			add_item(ItemData.weapon_descriptions[i[0]][1]+" x"+ str(i[1]))
			under_array.push_back([i[0], true])
		for i in PlayerInfo.active_save_data["active_weapons"]:
			if i!="":
				add_item(ItemData.weapon_descriptions[i][1]+ "   (Equipped)", null, false)
				under_array.push_back([i, false])
	elif(item=="Body"):
		for i in PlayerInfo.active_save_data["owned_bodies"]:
			add_item(ItemData.legs[i[0]].name+" x"+ str(i[1]))
			under_array.push_back([i[0], true])
		add_item(ItemData.bodies[PlayerInfo.active_save_data["active_body"]].name+ "   (Equipped)", null, false)
		under_array.push_back([PlayerInfo.active_save_data["active_body"], false])
	else:
		for i in PlayerInfo.active_save_data["owned_legs"]:
			add_item(ItemData.legs[i[0]].name+" x"+ str(i[1]))
			under_array.push_back([i[0], true])
		add_item(ItemData.legs[PlayerInfo.active_save_data["active_legs"]].name+ "   (Equipped)", null, false)
		under_array.push_back([PlayerInfo.active_save_data["active_legs"], false])

func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	Signals.update_details_screen.emit(under_array[index][0])
	curindex = index
func equip():
	print("ping2")
	if curindex!=-1:
		print("pong")
		if under_array[curindex][1]==true:
			print("ping")
