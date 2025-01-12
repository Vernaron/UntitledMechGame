extends Node2D
@export var default_settings : bool
@export var default_saves : bool 
var arena_res = preload("res://scenes/arena.tscn")
var base_res = preload("res://home_base.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	PlayerInfo.readSettings(default_settings)
	print(PlayerInfo.settings)
	PlayerInfo.get_saves(default_saves)
	start_base()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func start_arena():
	var temp_arena = arena_res.instantiate()
	temp_arena.name = "Arena"
	temp_arena.load_locale(temp_arena.localeNames.tundra)
	add_child(temp_arena)
func start_base():
	var temp_base = base_res.instantiate()
	add_child(temp_base)
