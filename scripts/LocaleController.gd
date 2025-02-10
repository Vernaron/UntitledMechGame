extends Node2D
var current_level : int = 1
var has_exited : bool = true
var first_exited : bool = false
@export var num_levels : int
# Called when the node enters the scene tree for the first time.
@onready var list_of_levels = []
@export var level_colors : Array[Color] = []
var ally_res = preload("res://scenes/mech_ally.tscn")
func _ready():
	for n in range(0, num_levels):
		list_of_levels.push_back(get_node("level_"+str(n)))
	Signals.spawn_root.connect(spawn)
	Signals.ascend.connect(ascend)
	Signals.descend.connect(descend)
	Signals.stair_exited.connect(stair_exited)
	var temp_ally = ally_res.instantiate()
	temp_ally.set_type(ItemData.Loadouts.Strider)
	temp_ally.construct("Ally")
	temp_ally.position = Vector2(848, -160)
	spawn(temp_ally)
	#remove_child(list_of_levels[1])
	#list_of_levels[1].process_mode = PROCESS_MODE_DISABLED
func spawn(node):
	list_of_levels[current_level].add_child(node)
func ascend(teleportPoint:Vector2):
	if(has_exited):
		
		has_exited=false
		first_exited = false
		current_level+=1
		list_of_levels[current_level].set_process_mode.call_deferred(PROCESS_MODE_INHERIT)
		list_of_levels[current_level-1].set_process_mode.call_deferred(PROCESS_MODE_DISABLED)
		Signals.teleport_player.emit(teleportPoint)
		Signals.shift_background_color.emit(level_colors[current_level])
		
		
func descend(teleportPoint:Vector2):
	if(has_exited):
		has_exited=false
		first_exited = false
		current_level-=1
		list_of_levels[current_level].set_process_mode.call_deferred(PROCESS_MODE_INHERIT)
		list_of_levels[current_level+1].set_process_mode.call_deferred(PROCESS_MODE_DISABLED)
		Signals.teleport_player.emit(teleportPoint)

		Signals.shift_background_color.emit(level_colors[current_level])
func stair_exited():
	if(first_exited):
		has_exited=true
	else:
		first_exited = true
