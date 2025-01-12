extends ItemList
var under_array :Array[Array]= []
var curr_index : int = 0
var target_type : String = "Body"
func _ready():
	Signals.change_inventory_type.connect(update_list)
func update_list(item:String):
	clear()
	curr_index = -1
	under_array = []
	target_type = item
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
			print(i)
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
	curr_index = index
func equip():
	print("ping2")
	if curr_index!=-1:
		print("pong")
		if under_array[curr_index][1]==true:
			match(target_type):
				"Weapon_1":
					equip_weapon(0, under_array[curr_index][0])
				"Weapon_2":
					equip_weapon(1, under_array[curr_index][0])
				"Weapon_3":
					equip_weapon(2, under_array[curr_index][0])
				"Weapon_4":
					equip_weapon(3, under_array[curr_index][0])
				"Weapon_5":
					equip_weapon(4, under_array[curr_index][0])
				"Body":
					equip_mech("owned_bodies", "active_body", under_array[curr_index][0])
				"Leg":
					equip_mech("owned_legs", "active_legs", under_array[curr_index][0])
			Signals.change_inventory_type.emit(target_type)
			PlayerInfo.save_player()
func equip_weapon(weapon_slot:int, value:String):
	for obj in PlayerInfo.active_save_data["owned_weapons"]:
		if obj[1]>0&&obj[0]==value: 
			add_or_append(PlayerInfo.active_save_data["owned_weapons"], PlayerInfo.active_save_data["active_weapons"][weapon_slot])
			subtract_from_array(PlayerInfo.active_save_data["owned_weapons"], value)
			PlayerInfo.active_save_data["active_weapons"][weapon_slot] = value
			break
			
func equip_mech(mech_part:String, active_part:String, value:String):
	print(mech_part, ", ", active_part, ", ", value)
	for obj in PlayerInfo.active_save_data[mech_part]:
		if obj[1]>0&&obj[0]==value: 
			add_or_append(PlayerInfo.active_save_data[mech_part], PlayerInfo.active_save_data[active_part])
			subtract_from_array(PlayerInfo.active_save_data[mech_part], value)
			PlayerInfo.active_save_data[active_part] = value
			break
			
func subtract_from_array(array_ref:Array, value:String):
	for n in array_ref:
		if n[0]==value:
			n[1]-=1
			if n[1]==0:
				array_ref.remove_at(array_ref.find(n))
			
func add_or_append(array_ref:Array, value : String):
	var found = false
	for n in array_ref:
		if n[0]==value:
			n[1]+=1
			found=true
			break
	if !found:
		array_ref.push_back([value, 1])
	
