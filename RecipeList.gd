extends ItemList
var underarray : Array
@export var details : Control
@export var item_window : AnimatedSprite2D
@export var materials : Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_crafting_list()
func update_crafting_list():
	clear()
	for obj in Crafting.recipes:
		var avail: bool = true
		print(PlayerInfo.active_save_data["found_materials"])
		for mat in obj.recipe:
			if mat.is_material&&PlayerInfo.active_save_data["found_materials"].find(mat.res_name)==-1:
				print(mat.res_name)
				avail = false 
		if avail:
			underarray.push_back(obj)
	print(underarray)
	for item in underarray:
		add_item(item.vis_name)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_activated(index: int) -> void:
	var curritem = underarray[index]
	materials.clear()
	for obj in curritem.recipe:
		materials.add_item(obj.disp_name)
	match(curritem.type):
		"body":
			print(curritem.res_name)
			item_window.sprite_frames = ItemData.bodies[curritem.res_name]["sprite"]
		"legs":
			print(curritem.res_name)
			item_window.sprite_frames = ItemData.legs[curritem.res_name]["sprite"]
		"weapons":
			pass
