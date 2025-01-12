extends Node2D
var player_res = preload("res://scenes/player.tscn")
var active_player
var basic_enemy_res = preload("res://scenes/mech_enemy.tscn")
var locales : Array[Resource] = [preload("res://scenes/Locales/defaultLocale.tscn"), preload("res://scenes/Locales/Tundra.tscn")]
enum localeNames{default = 0, tundra = 1}
func _ready():
	build_player() # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func load_locale(sceneName : localeNames):
	add_child(locales[sceneName].instantiate())
func build_player():
	active_player = player_res.instantiate()
	active_player.construct(
		"Player"
	)
	active_player.set_current_type(ItemData.control_type["Mech"])
	$mainCamera.set_target(active_player)
	PlayerInfo.target = active_player
	add_child(active_player)

func build_enemy():
	var basic_enemy = basic_enemy_res.instantiate()
	basic_enemy.set_type(ItemData.Basic_Enemy.Strider)
	basic_enemy.construct(
		"Enemy"
	)
	basic_enemy.position = Vector2(1000, 10)
	add_child(basic_enemy)	
