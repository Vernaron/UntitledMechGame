extends Node2D


# Called when the node enters the scene tree for the first time.
var target : Node2D = null
var saves = {}
var active_save_name = ""
var active_save_data = {}
var active = {
	"body":null,
	"leg":null,
	"leg_mod":[],
	"body_mod":[],
	"weapons":[]
}
var inventory = {
	"legs":[],
	"bodies":[],
	"modules":[],
	"weapons":[]
}
var progress = {
	
}
var default_save = {
	"save_ver":1.0,
	"owned_bodies":["strider_1"],
	"owned_legs":["strider_1"],
	"owned_modules":[],
	"owned_weapons":[["bolter",2]],
	"saved_inventory":[],
	"active_body":"strider_1",
	"active_legs":"strider_1",
	"active_body_mods":[],
	"active_leg_mods":[],
	"active_weapons":["bolter","bolter"],
	"active_zones":["zone_1"],
	"achievements":[],
	"player_level":1,
	"completed_tutorial":false
}
var settings = {}
var default_settings = {
	"intensity":1.0,
	"flashing":1.0,
	"particles": 0.0,
	"control_style":"keyboard",
	"save_files":["save_1", "save_2"],
	"last_active_save":"save_1"
}
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func readSettings(default : bool):
	settings = readFile("settings", default_settings, default)
func get_saves(default : bool):
	for save_name in settings["save_files"]:
		saves[save_name] = readFile(save_name, default_save, default)
	active_save_name = settings["last_active_save"]
	print(settings["last_active_save"])
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
func save_to_file():
	for save_name in saves.keys():
		writeFile(save_name+".data", saves[save_name])
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
		temp_arr.push_front(ItemData.weapons[weapon])
	return temp_arr
func get_active_legs():
	return ItemData.legs[PlayerInfo.active_save_data["active_legs"]]
func get_active_body():
	return ItemData.bodies[PlayerInfo.active_save_data["active_body"]]
