extends Node2D
class Quest:
	var name:String
	var display_name:String
	var map:Arena.localeNames
	var main_quest_unlocks:Array[String] = []
	var side_quest_unlocks:Array[String] = []
	var bounty_unlocks  :Array[String] = []
	var description : String
	var locale : Arena.localeNames
	func _init(_name : String, _display_name : String, \
		_main_quests : Array[String], _side_quests : Array[String], \
		_bounties : Array[String], _map:Arena.localeNames, _description : String)->void:
		name = _name
		display_name = _display_name
		main_quest_unlocks = _main_quests
		side_quest_unlocks = _side_quests
		bounty_unlocks = _bounties
		description = _description
		map = _map
	func start()->void:
		pass
var main_quests := {
	"test_1":Quest.new("test_1","Test1",["test_2"],["test_sidequest_1"],["test_bounty_1"],Arena.localeNames.tundra,"This is a test"),
	"test_2":Quest.new("test_2","Test2",[],[],[],Arena.localeNames.tundra,"This is a second test")
}
var side_quests := {
	"test_sidequest_1":Quest.new("test_sidequest_1","SideQuest1", [],["test_sidequest_2"],["test_bounty_2"],Arena.localeNames.tundra,"This is a sidequest test"),
	"test_sidequest_2":Quest.new("test_sidequest_2","SideQuest2", [],["test_sidequest_3"],[],Arena.localeNames.tundra,"This is a second sidequest test"),
	"test_sidequest_3":Quest.new("test_sidequest_3","SideQuest3", [],[],[],Arena.localeNames.tundra,"This is a third sidequest test"),
}
var bounties:={
	"test_bounty_1":Quest.new("test_bounty_1","Bounty1", [],[],[],Arena.localeNames.tundra,"This is a bounty"),
	"test_bounty_2":Quest.new("test_bounty_2","Bounty2", [],[],[],Arena.localeNames.tundra,"This is a second bounty"),
	"test_bounty_3":Quest.new("test_bounty_3","Bounty3", [],[],[],Arena.localeNames.tundra,"This is a third bounty"),
}
