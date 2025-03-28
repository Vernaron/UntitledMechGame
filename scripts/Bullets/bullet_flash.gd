@tool
extends PointLight2D
@export var size : float
@export var growspeed:float
@export var shrinkspeed:float
var isShrinking := false
var doscale := true
var self_flash := preload("res://scenes/Bullet_Adjacent/bullet_flash.tscn")
var countdown : float
# Called when the node enters the scene tree for the first time.
func _ready()->void:
	if(doscale):
		texture_scale = .1
	#if doscale: texture_scale = .01

func init(_size:float, _color:Color, _growspeed:float, _shrinkspeed:float, _doscale:bool)->PointLight2D:
	size = _size
	color = _color
	growspeed = _growspeed
	shrinkspeed = _shrinkspeed
	doscale = _doscale
	countdown = shrinkspeed+growspeed
	scale = Vector2(size, size)
	return self
func copy()->PointLight2D:
	var temp_flash :PointLight2D= self_flash.instantiate().init(size, color, growspeed, shrinkspeed, doscale)
	temp_flash.position = position
	return temp_flash
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	if(!Engine.is_editor_hint()):
		if(doscale):
			if(isShrinking):
				texture_scale-=size*delta/shrinkspeed
				color = Color(color.r, color.g, color.b, max(color.a-(delta)/shrinkspeed, 0))
				if(texture_scale<=.0001):
					queue_free()
			else:
				texture_scale+=size*delta/growspeed
				if(texture_scale>size):
					texture_scale = size
					isShrinking=true
		else:
			countdown-=delta
			if(countdown < 0):
				queue_free()
