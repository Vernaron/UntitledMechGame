extends CanvasLayer
@export var isCombatZone : bool = false
var inSettings := false
# Called when the node enters the scene tree for the first time.
func _ready()->void:
	if(!isCombatZone):
		$MainContainer/Control/Control/PanelContainer/mainMenuContainer/combatButton.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
	if Input.is_action_just_pressed("escape_button")&&get_tree().paused==false:
		get_tree().paused = true
		visible = true
	elif Input.is_action_just_pressed("escape_button")&&get_tree().paused==true&&!inSettings:
		get_tree().paused = false
		Signals.unpause.emit();
		visible = false
	elif Input.is_action_just_pressed("escape_button")&&get_tree().paused==true&&inSettings:
		$MainContainer/settingsPanel.visible = false
		$MainContainer/Control/Control/PanelContainer.visible = true
		print("Something")
		inSettings = false
		
func settings_pressed()->void:
	
	inSettings = !inSettings
	print(inSettings)
