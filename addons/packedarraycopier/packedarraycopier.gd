@tool
extends Node2D
class_name PackedArrayPrinter
@export var array : PackedVector2Array
@export var isActive:bool = false
var array_printable = ""
func _enter_tree():
	# Initialization of the plugin goes here.
	pass

func _process(delta):
	if isActive:
		array_printable = "PackedVector2Array(["
		for item in array:
			array_printable+="Vector2("+str(item[0])+","+str(item[1])+"),"
		array_printable+="]),"
		print(array_printable)
		isActive = false
func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
