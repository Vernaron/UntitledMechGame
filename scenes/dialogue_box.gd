extends CanvasLayer
var curr_name : String = ""
var next_name : String = ""
var isActive : bool= false
var blurb_queue : Array[String] = []
var countdown : float = 5
var darknameplate : Resource = preload("res://NameplateDark.tres")
var nameplate : Resource = preload("res://Nameplate.tres")
class blurb: 
	var left_speaker : String = ""
	var left_name : String = ""
	var right_speaker : String = ""
	var right_name : String = ""
	var highlighted : String = "both" #left right both neither
	var text : String = ""
	var nextblurb : String = ""
	func _init(_left_speaker:String, _right_speaker:String, _highlighted:String,_left_name:String,_right_name:String, _text:String, _nextblurb := "")->void:
		left_speaker = _left_speaker
		right_speaker = _right_speaker
		highlighted = _highlighted
		left_name = _left_name
		right_name = _right_name
		text = _text
		nextblurb = _nextblurb
var portraits := {
	"":null,
	"generic_black": preload("res://assets/portraits/generic_portrait.png"),
	"generic_grey" : preload("res://assets/portraits/generic_portrait_grey.png"),
	"generic_white": preload("res://assets/portraits/generic_portrait_white.png"),
}
var dialogues := {
	"":blurb.new("","","neither","" ,"",""),
	"test":blurb.new("generic_black", "generic_white", "right","The Left One","The Right One", "asngajgggajgjangjdgdgalgjgagjjjjhhh", "test2"),
	"test2":blurb.new("generic_grey", "", "left","Spooky Figure","", "HA you thought it would be just one didnt you"),
	"boom":blurb.new("generic_white","","neither","","","BOOM Gotya!")
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.start_dialogue.connect(queue_dialogue)
	#queue_dialogue("test")
	#queue_dialogue("boom")

func queue_dialogue(blurb_name : String)->void:
	if !isActive:
		process_dialogue(blurb_name)
	else:
		blurb_queue.push_back(blurb_name)
func process_dialogue(blurb_name : String)->void:
	isActive=true
	visible = true
	countdown = 5
	var currblurb : blurb= dialogues[blurb_name]
	curr_name = blurb_name
	next_name = currblurb.nextblurb
	match(currblurb.highlighted):
		"left":
			$spriteL/nameL.add_theme_stylebox_override("normal",nameplate)
			$spriteR/nameR.add_theme_stylebox_override("normal",darknameplate)
			$spriteL/nameL.modulate = Color(1,1,1,1.0)
			$spriteR/nameR.modulate = Color(0.8,0.8,0.8,1.0)
			$spriteL.scale = Vector2(2,2)
			$spriteR.scale = Vector2(1.5,1.5)
			$spriteL.z_index = 1
			$spriteR.z_index = -2
		"right":
			$spriteL/nameL.add_theme_stylebox_override("normal",darknameplate)
			$spriteR/nameR.add_theme_stylebox_override("normal",nameplate)
			$spriteL/nameL.modulate = Color(.8,.8,.8,1.0)
			$spriteR/nameR.modulate = Color(1,1,1,1.0)
			$spriteL.scale = Vector2(1.5,1.5)
			$spriteR.scale = Vector2(2,2)
			$spriteL.z_index = -2
			$spriteR.z_index = 1
	$spriteL/nameL.text = currblurb.left_name
	$spriteR/nameR.text = currblurb.right_name
	$spriteR.texture = portraits[currblurb.right_speaker]
	$spriteL.texture = portraits[currblurb.left_speaker]
	if currblurb.right_speaker=="":
		$spriteR/nameR.visible = false
	else:
		$spriteR/nameR.visible = true
	if currblurb.left_speaker=="":
		$spriteL/nameL.visible = false
	else:
		$spriteL/nameL.visible = true
	
	$Text.process_text(currblurb.text)
	
	
func _process(delta:float)->void:
	if $Text.done&&isActive:
		countdown-=delta
	if countdown<=0||(Input.is_action_just_pressed("dialogue_next")&&isActive):
		if !$Text.done:
			$Text.accelerate()
		elif next_name!="":
			process_dialogue(next_name)
		elif blurb_queue!=[]:
			process_dialogue(blurb_queue[0])
			blurb_queue.pop_front()
		else:
			countdown=5
			isActive=false
			visible=false
			next_name=""
			curr_name=""
