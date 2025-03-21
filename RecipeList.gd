extends ItemList
var underarray : Array
var curr_type : String = "Body"
var curritem : Crafting.CraftingRecipe = null
@export var details : Control
@export var item_window : AnimatedSprite2D
@export var materials : Control
var active_recipe : Crafting.CraftingRecipe
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.change_inventory_type.connect(update_type)
	update_crafting_list()
func update_type(newtype:String)->void:
	curr_type = newtype
	update_crafting_information()
func update_crafting_information()->void:
	if curritem!=null:
		materials.clear()
		var tooltip_index :int= 0
		for obj in curritem.recipe:
			var res_found := false
			var res_num :int= 0
			if obj.is_material:
				for n :Array in PlayerInfo.active_save_data["materials"]:
					if n[0]==obj.res_name:
						res_found=true
						res_num=n[1]
						break
				if res_found:
					materials.add_item(obj.disp_name+" (" + str(res_num)+ "/"+str(obj.count)+")")
				else:
					materials.add_item(obj.disp_name+" (0/"+str(obj.count)+")")
			else:
				materials.add_item(obj.disp_name + " ("+ str(PlayerInfo.get_number_in_inventory(obj.res_name, obj.res_type))+"/"+str(obj.count)+")")
			materials.set_item_tooltip_enabled(tooltip_index, false)
			tooltip_index+=1
		details.set_index_dictionary(curritem.type)
		details.update_details(curritem.res_name)
func update_crafting_list()->void:
	clear()
	for obj in Crafting.recipes:
		var avail: bool = true
		for mat in obj.recipe:
			if mat.is_material&&PlayerInfo.active_save_data["found_materials"].find(mat.res_name)==-1:
				avail = false 
		if avail:
			underarray.push_back(obj)
	var tooltip_index :int= 0
	for item :Crafting.CraftingRecipe in underarray:
		add_item(item.vis_name)
		set_item_tooltip_enabled(tooltip_index,false)
		tooltip_index+=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_item_activated(index: int) -> void:
	curritem = underarray[index]
	
	active_recipe = curritem
	update_crafting_information()
	item_window.sprite_frames = ItemData.get_image(curritem.res_name, curritem.type)
	
func craft()->void:
	var isCraftable := true
	if active_recipe!=null:
		for obj in active_recipe.recipe:
			var res_found := false
			#var res_num :int= 0
			var less_than:=true
			if obj.is_material:
				for n :Array in PlayerInfo.active_save_data["materials"]:
					if n[0]==obj.res_name:
						res_found=true
						if n[1]>=obj.count:
							less_than=false
						break
			else:
				res_found=true
				if PlayerInfo.get_number_in_inventory(obj.res_name, obj.res_type)>=obj.count:
					print("there")
					less_than=false
			if(!res_found||less_than):
				print("here")
				isCraftable=false
				break
			print(isCraftable)
	else:
		isCraftable = false
	if isCraftable:
		
		active_recipe.subtract_materials_from_storage()
		match(active_recipe.type):
			"Body":
				PlayerInfo.add_or_append(PlayerInfo.active_save_data["owned_bodies"], active_recipe.res_name)
			"Weapon":
				PlayerInfo.add_or_append(PlayerInfo.active_save_data["owned_weapons"], active_recipe.res_name)
			"Leg":
				PlayerInfo.add_or_append(PlayerInfo.active_save_data["owned_legs"], active_recipe.res_name)
		Signals.change_inventory_type.emit(curr_type)
		PlayerInfo.save_player()
