extends TabBar

var tabs = ["Graphics", "Controls"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tab_changed(tab):
	for i in tabs:
		if i==tabs[tab]:
			get_parent().find_child(i).visible = true
		else:
			get_parent().find_child(i).visible = false
