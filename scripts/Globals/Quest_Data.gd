extends Node2D
class Quest:
	var name:String
	var display_name:String
	var main_quest_unlocks:Array = []
	var side_quest_unlocks:Array = []
	var subquest_unlocks  :Array = []
	var description : String
	var locale : Arena.localeNames
	func _init(_name : String, _display_name : String, \
		_main_quests : Array, _side_quests : Array, \
		_subquests : Array, _description : String)->void:
		name = _name
		display_name = _display_name
		main_quest_unlocks = _main_quests
		side_quest_unlocks = _side_quests
		subquest_unlocks = _subquests
		description = _description
	func start()->void:
		pass
var main_quests := {
	
}
var subquests := {
	
}
var side_quests:={
	
}
