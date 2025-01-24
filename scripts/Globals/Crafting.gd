extends Node
class mat:
	extends Resource
	var materials = {
		"screws":"Screws",
		"plates":"Plates"
	}
	var res_name : String = ""
	var disp_name : String = ""
	var count : int =0
	var is_material : bool = true
	func init(_res_name: String, _count:int)->mat:
		res_name = _res_name
		count = _count
		is_material = materials.has(_res_name)
		if materials.has(_res_name):
			disp_name = materials[_res_name]
		return self
class CraftingRecipe:
	extends Resource
	var res_name : String = ""
	var type : String = ""
	var vis_name : String = ""
	var recipe : Array[mat] = []
	func init(_name : String, _type : String, _vis_name : String, _recipe : Array[mat]):
		res_name = _name
		type = _type
		vis_name = _vis_name
		recipe = _recipe
		return self
	
var recipes : Array[CraftingRecipe] = [
	CraftingRecipe.new().init("strider_1", "body", "Strider Body", 
		[mat.new().init("screws",5),mat.new().init("plates",10)]),
	CraftingRecipe.new().init("strider_1", "legs", "Strider Legs", 
		[mat.new().init("screws",5),mat.new().init("plates",10)]),
	
]
