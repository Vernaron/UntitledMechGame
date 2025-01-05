extends TabBar

var tabs = ["Graphics", "Controls"]
# Called when the node enters the scene tree for the first time.

func _on_tab_changed(tab):
	for i in tabs:
		if i==tabs[tab]:
			get_parent().find_child(i).visible = true
		else:
			get_parent().find_child(i).visible = false
