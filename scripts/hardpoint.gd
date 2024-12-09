extends Node2D
@export_range(1, 3) var type = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func build(info : Array):
	type = info[1]
	position = info[0]
func _fire():
	pass
