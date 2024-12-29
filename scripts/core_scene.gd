extends Node2D
@export var default_settings : bool
@export var default_saves : bool 
var arena_res = preload("res://scenes/arena.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	PlayerInfo.readSettings(default_settings)
	print(PlayerInfo.settings)
	PlayerInfo.get_saves(default_saves)
	var temp_arena = arena_res.instantiate()
	temp_arena.name = "Arena"
	add_child(temp_arena)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
