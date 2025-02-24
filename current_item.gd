extends Button
var underitem : String = ""
func _ready()->void:
	Signals.change_inventory_type.connect(update_item)
func update_item(item : String)->void:
	
	if (item.find("Weapon")!=-1):
		var fixedtype := item.substr(0, item.length()-2)
		var num := item.substr(item.length()-1).to_int()-1
		Signals.update_details_screen.emit.call_deferred(PlayerInfo.active_save_data["active_weapons"][num])
		text =ItemData.get_display_name(PlayerInfo.active_save_data["active_weapons"][num],fixedtype)
		underitem = PlayerInfo.active_save_data["active_weapons"][num]
	elif(item=="Body"):
		Signals.update_details_screen.emit.call_deferred(PlayerInfo.active_save_data["active_body"])
		text = ItemData.get_display_name(PlayerInfo.active_save_data["active_body"],item)
		underitem = PlayerInfo.active_save_data["active_body"]
	else:
		Signals.update_details_screen.emit.call_deferred(PlayerInfo.active_save_data["active_legs"])
		text = ItemData.get_display_name(PlayerInfo.active_save_data["active_legs"],item)
		underitem = PlayerInfo.active_save_data["active_legs"]	


func _on_pressed() -> void:
	Signals.update_details_screen.emit(underitem)
	get_parent().get_node("ItemList").curr_index=-1
	get_parent().get_node("ItemList").deselect_all()
