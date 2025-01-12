@tool
extends PointLight2D
@export var size : float
@export var growspeed:float
@export var shrinkspeed:float
var isShrinking = false
var doscale = true
var self_flash = preload("res://scenes/Bullet_Adjacent/bullet_flash.tscn")
var countdown
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if doscale: texture_scale = .01

func init(_size, _color, _growspeed, _shrinkspeed, _doscale):
	size = _size
	color = _color
	growspeed = _growspeed
	shrinkspeed = _shrinkspeed
	doscale = _doscale
	countdown = shrinkspeed+growspeed
	gettexture()
	return self
func gettexture():
	await RenderingServer.frame_post_draw
func copy():
	var temp_flash = self_flash.instantiate().init(size, color, growspeed, shrinkspeed, doscale)
	temp_flash.position = position
	return temp_flash
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(doscale):
		if(isShrinking):
			texture_scale-=size*delta/shrinkspeed
			color = Color(color.r, color.g, color.b, max(color.a-(2*delta)/shrinkspeed, 0))
			if(texture_scale<=.01):
				queue_free()
		else:
			texture_scale+=size*delta/growspeed
			if(texture_scale>size):
				isShrinking=true
	else:
		countdown-=delta
		if(countdown < 0):
			queue_free()
