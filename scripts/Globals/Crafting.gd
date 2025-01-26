extends Node
class mat:
	extends Resource
	var materials = {
		"screws":"Screws",
		"plates":"Plates"
	}
	var res_name : String = ""
	var res_type : String = ""
	var disp_name : String = ""
	var count : int =0
	var is_material : bool = true
	func _init(_res_name: String, _count:int, _res_type : String = "", suffix : String = ""):
		res_name = _res_name
		res_type = _res_type
		count = _count
		is_material = res_type ==""
		if materials.has(_res_name):
			disp_name = materials[_res_name]
		else:
			disp_name = ItemData.get_display_name(res_name, res_type) + suffix
	func subtract_from_inventory():
		for x in range(0, count):
			if(is_material):	
				PlayerInfo.subtract_from_array(PlayerInfo.active_save_data["materials"], res_name)
			else:
			
				if res_type.find("Weapons")!=-1:
					PlayerInfo.subtract_from_array(PlayerInfo.active_save_data["owned_weapons"], res_name)
				elif(res_type =="Body"):
					PlayerInfo.subtract_from_array(PlayerInfo.active_save_data["owned_bodies"], res_name)
				else:
					PlayerInfo.subtract_from_array(PlayerInfo.active_save_data["owned_legs"], res_name)
class CraftingRecipe:
	extends Resource
	var res_name : String = ""
	var type : String = ""
	var vis_name : String = ""
	var recipe : Array[mat] = []
	func _init(_name : String, _type : String, _vis_name : String, _recipe : Array[mat]):
		res_name = _name
		type = _type
		vis_name = _vis_name
		recipe = _recipe
	func subtract_materials_from_storage():
		for n in recipe:
			n.subtract_from_inventory()
var recipes : Array[CraftingRecipe] = [
	CraftingRecipe.new("strider_1", "Body", "Strider Body", 
		[mat.new("screws",5),mat.new("plates",10)]),
	CraftingRecipe.new("strider_1", "Leg", "Strider Legs", 
		[mat.new("screws",5),mat.new("plates",10)]),
	CraftingRecipe.new("bulwark_1", "Body", "Bulwark Body",
	[mat.new("screws", 10),mat.new("plates", 5), mat.new("strider_1", 1, "Body", " Body")]),
	CraftingRecipe.new("bulwark_1", "Leg", "Bulwark Legs",
	[mat.new("screws", 10),mat.new("plates", 5), mat.new("strider_1", 1, "Leg", " Legs")])
]
