extends Node2D


# Called when the node enters the scene tree for the first time.
var bodies_list = {}
var legs_list = {}
var weapons_list = {}
var target : Node2D = null
var bodies=[]
var legs=[]
var modules = []
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
var settings
var default_settings = {
	"intensity":1.0,
	"flashing":1.0,
	"control_style":"keyboard"
}
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func readSettings():
	settings = readFile("settings", default_settings)

func readFile(filename:String, default:Dictionary)->Variant : 
	var filepath = "user://"+filename+".data"
	if(FileAccess.file_exists(filepath)):
		return JSON.parse_string(FileAccess.open(filepath,FileAccess.READ).get_line())
	else:
		writeFile(filename, default)
		return default 
func writeFile(filename:String, value:Dictionary)->void:
	var filepath = "user://"+filename+".data"
	FileAccess.open(filepath, FileAccess.WRITE).store_string(
			JSON.stringify(value))
