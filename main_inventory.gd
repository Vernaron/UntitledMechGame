extends ItemList
var under_array :Array[Array]= []
var curr_index : int = 0
var target_type : String = "Body"
func _ready()->void:
	Signals.change_inventory_type.connect(update_list)
func update_list(item:String)->void:
	clear()
	curr_index = -1
	under_array = []
	target_type = item
	if(item.find("Weapon")!=-1):
		var type := item.substr(0, item.length()-2)
		for i:Array in PlayerInfo.active_save_data["owned_weapons"]:
			add_item(ItemData.get_display_name(i[0],type)+" x"+ str(i[1]))
			under_array.push_back([i[0], true])
		for i:String in PlayerInfo.active_save_data["active_weapons"]:
			if i!="":
				add_item(ItemData.get_display_name(i,type)+ "   (Equipped)", null, false)
				under_array.push_back([i, false])
	elif(item=="Body"):
		for i:Array in PlayerInfo.active_save_data["owned_bodies"]:
			add_item(ItemData.get_display_name(i[0],item)+" x"+ str(i[1]))
			under_array.push_back([i[0], true])
		add_item(ItemData.get_display_name(PlayerInfo.active_save_data["active_body"],item)+ "   (Equipped)", null, false)
		under_array.push_back([PlayerInfo.active_save_data["active_body"], false])
	else:
		for i:Array in PlayerInfo.active_save_data["owned_legs"]:
			add_item(ItemData.get_display_name(i[0],item)+" x"+ str(i[1]))
			under_array.push_back([i[0], true])
		add_item(ItemData.get_display_name(PlayerInfo.active_save_data["active_legs"],item)+ "   (Equipped)", null, false)
		under_array.push_back([PlayerInfo.active_save_data["active_legs"], false])

func _on_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	Signals.update_details_screen.emit(under_array[index][0])
	curr_index = index
	get_parent().get_node("Current_Item").button_pressed = false
func equip()->void:
	if curr_index!=-1&&under_array!=[]:
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
func equip_weapon(weapon_slot:int, value:String)->void:
	var tag_list : Array[ItemData.Tag] = ItemData.bodies[PlayerInfo.active_save_data["active_body"]].hardpoints[weapon_slot][1] 
	for tag : ItemData.Tag in ItemData.weapons[value].tags:
		if !tag.has_valid_tag(tag_list):
			return
	for obj : Array in PlayerInfo.active_save_data["owned_weapons"]:
		if obj[1]>0&&obj[0]==value:

			if PlayerInfo.active_save_data["active_weapons"][weapon_slot]!="":add_or_append(PlayerInfo.active_save_data["owned_weapons"], PlayerInfo.active_save_data["active_weapons"][weapon_slot])
			subtract_from_array(PlayerInfo.active_save_data["owned_weapons"], value)
			PlayerInfo.active_save_data["active_weapons"][weapon_slot] = value
			break
func unequip_weapon(weapon_slot:int)->void:	
	
	if PlayerInfo.active_save_data["active_weapons"][weapon_slot]!="": 
		add_or_append(PlayerInfo.active_save_data["owned_weapons"], PlayerInfo.active_save_data["active_weapons"][weapon_slot])
		PlayerInfo.active_save_data["active_weapons"][weapon_slot] = ""
func equip_mech(mech_part:String, active_part:String, value:String)->void:
	for obj :Array in PlayerInfo.active_save_data[mech_part]:
		if obj[1]>0&&obj[0]==value: 
			add_or_append(PlayerInfo.active_save_data[mech_part], PlayerInfo.active_save_data[active_part])
			subtract_from_array(PlayerInfo.active_save_data[mech_part], value)
			PlayerInfo.active_save_data[active_part] = value
			break
	update_hardpoints()		

	if(active_part=="active_body"):
		get_parent().body_changed.emit()
func subtract_from_array(array_ref:Array, value:String)->void:
	for n : Array in array_ref:
		if n[0]==value:
			n[1]-=1
			if n[1]==0:
				array_ref.remove_at(array_ref.find(n))
			
func add_or_append(array_ref:Array, value : String)->void:
	var found := false
	for n : Array in array_ref:
		if n[0]==value:
			n[1]+=1
			found=true
			break
	if !found:
		array_ref.push_back([value, 1])
	
func update_hardpoints()->void:
	for n in range(0, PlayerInfo.active_save_data["active_weapons"].size()):
		var hardpoint_size :int= ItemData.bodies[PlayerInfo.active_save_data["active_body"]].hardpoints[n][1]

		if(PlayerInfo.active_save_data["active_weapons"][n]!=""&&hardpoint_size<ItemData.weapons[
				PlayerInfo.active_save_data["active_weapons"][n]].size_level):
			unequip_weapon(n)


func _on_item_activated(_index: int) -> void:
	equip()
