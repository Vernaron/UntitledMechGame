@tool
extends Sprite2D
var itemData_res = load("res://scripts/Item_Data.gd")
var point_res = preload("res://scenes/hardpoint_visual.tscn")
var printer = preload("res://addons/packedarraycopier/packedarraycopier.gd").new()
var itemData = itemData_res.new()
var hardpointList = []
@export_enum("strider_1", "bulwark_1") var Reference : String 
@export var Reload : bool
@export var Save : bool
var active_string = ""

# Called when the node enters the scene tree for the first time.
func _ready():
		hardpointList = get_children()
		var num = hardpointList.size()-1
		while(num>=0):
				hardpointList[num].queue_free()
				num-=1
		hardpointList = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		if(Save && active_string!=""):
			Save = false
			notify_property_list_changed()
			var tempLocations = ""
			for node in get_children():
				tempLocations+="[Vector2"+str(node.position*4)+", "+ node.name.right(1)+"],"
				
			print(tempLocations)
			printer.array = get_parent().get_parent().find_child("LegCollisionPolygon").polygon
			printer.isActive = true
			printer._process(delta)
		if Reference!=active_string && Reference != "" || Reload:
			itemData = itemData_res.new()
			Reload = false
			active_string = Reference
			var num = hardpointList.size()-1
			while(num>=0):
				hardpointList[num].queue_free()
				remove_child(hardpointList[num])
				num-=1
			hardpointList = []
			notify_property_list_changed()
			num = 0
			texture = itemData.bodies[active_string]["sprite"]
			get_parent().get_parent().find_child("LegCollisionPolygon").polygon = itemData.bodies[active_string]["collision_array_points"]
			get_parent().get_parent().find_child("LegCollisionPolygon").notify_property_list_changed()
			print(get_children())
			for hardpoint in itemData.bodies[active_string]["hardpoints"]:
				var hardNode = point_res.instantiate()
				hardNode.position = hardpoint[0]/4
				hardNode.name = "Hardpoint_" +str(num)+"_"+str(hardpoint[1]) 
				num+=1
				hardpointList.push_back(hardNode)
				
				add_child(hardNode)
				hardNode.owner = get_tree().edited_scene_root
			
			


