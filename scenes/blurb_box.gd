extends TextEdit
var buffer : String = ""
var next : String = ""
@export var process_speed : float = 0.5
var curr_time : float =0
var done : bool = true
# Called when the node enters the scene tree for the first time.
func process_text(thetext : String)->void:
	print(thetext)
	buffer = thetext
	text = ""
func accelerate()->void:
	if buffer!="":
		text+=buffer
		buffer=""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if buffer!="":
		done = false
		while curr_time<=0:
			if curr_time<=0:
				text+=buffer[0]
				buffer = buffer.substr(1)
				curr_time += process_speed
		if curr_time>0:
			curr_time -=delta
	else:
		if buffer=="" &&text !=""&&!done:
			text+="\nPress E to continue..."
		done = true
