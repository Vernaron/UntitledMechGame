extends CanvasLayer
var curr_name : String = ""
class blurb: 
	var left_speaker : Resource = null
	var right_speaker : Resource = null
	var highlighted : String = "both" #left right both neither
	var text : String = ""
	var nextblurb : String = ""
	func _init(_left_speaker, _right_speaker, _highlighted, _text):
		left_speaker = _left_speaker
		right_speaker = _right_speaker
		_highlighted = _highlighted
		_text = text
var dialogues = {
	"":blurb.new(null,null,"neither", "")
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.start_dialogue.connect(process_dialogue)


func process_dialogue(name : String):
	var currblurb = dialogues[name]
	
