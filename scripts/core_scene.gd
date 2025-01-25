extends Node2D
@export var default_settings : bool
@export var default_saves : bool 
var arena_res = preload("res://scenes/arena.tscn")
var base_res = preload("res://home_base.tscn")
var current_page : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.start_combat_area.connect(start_arena)
	Signals.start_base.connect(start_base)
	randomize()
	PlayerInfo.readSettings(default_settings)
	print(PlayerInfo.settings)
	PlayerInfo.get_saves(default_saves)
	start_base()


func start_arena(arenaName : Arena.localeNames):
	var temp_arena = arena_res.instantiate()
	temp_arena.name = "Arena"
	temp_arena.load_locale(arenaName)
	switch_primary_scene(temp_arena)
func start_base():
	PlayerInfo.save_player()
	var temp_base = base_res.instantiate()
	switch_primary_scene(temp_base)
func switch_primary_scene(newScene):
	if current_page!=null:
		current_page.queue_free()
		current_page=null
	current_page = newScene
	add_child(newScene)
