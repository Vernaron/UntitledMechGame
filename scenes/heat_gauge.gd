extends ProgressBar
var theme_override : StyleBox = self["theme_override_styles/fill"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var heat : float = PlayerInfo.target.heat
	value = heat
	if value>=.98:value=1.00
	theme_override.bg_color = Color.from_hsv(0.25*(1.0-heat),.65, .6)
	add_theme_stylebox_override("fill",theme_override)
