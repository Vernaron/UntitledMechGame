extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape_button")&&get_tree().paused==false:
		get_tree().paused = true
		visible = true
	elif Input.is_action_just_pressed("escape_button")&&get_tree().paused==true:
		get_tree().paused = false
		visible = false
