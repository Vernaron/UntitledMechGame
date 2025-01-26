extends Node2D

var target : Node2D = null
var saves = {}
var active_save_name = ""
var active_save_data = {}

var progress = {
	
}
var default_save = {
	"save_ver":1.0,
	"owned_bodies":[["strider_1",1]],
	"owned_legs":[["strider_1", 1]],
	"owned_modules":[],
	"owned_weapons":[["bolter",2]],
	"saved_inventory":[],
	"active_body":"strider_1",
	"active_legs":"strider_1",
	"active_body_mods":[],
	"active_leg_mods":[],
	"active_weapons":["bolter","bolter","","",""],
	"active_zones":["zone_1"],
	"achievements":[],
	"materials":[],
	"found_materials":[],
	"player_level":1,
	"completed_tutorial":false
}
var settings = {}
var default_settings = {
	"intensity":1.0,
	"flashing":1.0,
	"particles": 1.0,
	"control_style":"keyboard",
	"save_files":["save_1", "save_2"],
	"last_active_save":"save_1"
}

func get_number_in_inventory(equipment_name : String, equipment_type : String)->int:
	var finalval : int = 0
	if equipment_type.find("Weapon") !=-1:
		for i in active_save_data["owned_weapons"]:
			if i[0]==equipment_name:
				finalval+=i[1]
	elif equipment_type == "Body":
		for i in active_save_data["owned_bodies"]:
			if i[0]==equipment_name:
				finalval+=i[1]
	else:
		for i in active_save_data["owned_legs"]:
			if i[0]==equipment_name:
				finalval+=i[1]
	return finalval
func readSettings(default : bool):
	settings = readFile("settings", default_settings, default)
	Signals.SettingsChange.emit()
func get_saves(default : bool):
	for save_name in settings["save_files"]:
		saves[save_name] = readFile(save_name, default_save, default)
	active_save_name = settings["last_active_save"]
	active_save_data = saves[settings["last_active_save"]] 
func switch(_save_name):
	if saves[_save_name] != null:
		active_save_name = _save_name
		active_save_data = saves[_save_name]
	else:
		active_save_name = _save_name
		active_save_data = default_save
		saves[_save_name] = default_save
func save_player():
	saves[active_save_name] = active_save_data
	save_to_file()
func save_to_file():
	for save_name in saves.keys():
		writeFile(save_name, saves[save_name])
func readFile(filename:String, default:Dictionary, using_default : bool)->Variant : 
	var filepath = "user://"+filename+".data"
	if(FileAccess.file_exists(filepath)&&!using_default):
		return JSON.parse_string(FileAccess.open(filepath,FileAccess.READ).get_line())
	else:
		writeFile(filename, default)
		return default 
func writeFile(filename:String, value:Dictionary)->void:
	var filepath = "user://"+filename+".data"
	FileAccess.open(filepath, FileAccess.WRITE).store_string(
			JSON.stringify(value))
func get_active_weapons():
	var temp_arr = []
	for weapon in PlayerInfo.active_save_data["active_weapons"]:
		if weapon!="":
			temp_arr.push_back(ItemData.weapons[weapon])
	return temp_arr
func get_active_legs():
	return ItemData.legs[PlayerInfo.active_save_data["active_legs"]]
func get_active_body():
	return ItemData.bodies[PlayerInfo.active_save_data["active_body"]]
func collect_drop(item : String, number : int):
	if(item.find("weapon_")!=-1):
		item = item.substr(7)
		add_or_append(active_save_data["owned_weapons"], item)
	elif(item.find("body_")!=-1):
		item = item.substr(5)	
		add_or_append(active_save_data["owned_bodies"], item)
	elif(item.find("legs_")!=-1):
		item = item.substr(5)
		add_or_append(active_save_data["owned_legs"], item)
	else:
		register_new_material(item)
		add_or_append(active_save_data["materials"], item)
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
func register_new_material(obj:String):
	if active_save_data["found_materials"].find(obj)==-1:
		active_save_data["found_materials"].push_back(obj)
