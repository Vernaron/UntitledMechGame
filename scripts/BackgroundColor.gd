extends ColorRect
@onready var nextColor : Color = Color(0.227, 0.227, 0.298, 1.0)

func _ready()->void:
	Signals.shift_background_color.connect(shift_color)
	print(color)
func shift_color(newColor:Color)->void:
	nextColor = newColor
func _process(_delta:float)->void:
	if(nextColor!=color):
		var colordiff := nextColor-color
		color+=colordiff/10
			
