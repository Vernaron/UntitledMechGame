extends ColorRect
@onready var nextColor : Color = Color(0.4, 0.4, 0.4, 1.0)

func _ready():
	Signals.shift_background_color.connect(shift_color)
	print(color)
func shift_color(newColor):
	nextColor = newColor
func _process(_delta):
	if(nextColor!=color):
		var colordiff = nextColor-color
		color+=colordiff/10
			

