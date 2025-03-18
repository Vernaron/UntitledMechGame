extends ItemList
var current_quests: Array[String] = []
var next_quests: Array[String] = []
var under_array:Array[String] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_quests()
func get_quests()->void:
	current_quests.append_array(PlayerInfo.active_save_data["completed_side_quest"])
	for completed_quest : String in PlayerInfo.active_save_data["completed_side_quest"]:
		var current_quest : QuestData.Quest = QuestData.side_quests[completed_quest]
		for next_quest in current_quest.side_quest_unlocks:
			if PlayerInfo.active_save_data["completed_side_quest"].find(next_quest)==-1:
				next_quests.push_back(next_quest)
	for completed_quest : String in PlayerInfo.active_save_data["completed_main_quest"]:
		var current_quest : QuestData.Quest = QuestData.main_quests[completed_quest]
		for next_quest in current_quest.side_quest_unlocks:
			if PlayerInfo.active_save_data["completed_side_quest"].find(next_quest)==-1:
				next_quests.push_back(next_quest)
	for i in range(0, next_quests.size()):
		add_item(next_quests[i])
		set_item_custom_bg_color(i, Color(0.3,0.3,0.6))
		under_array.push_back(next_quests[i])
	for i in range(0,current_quests.size()):
		add_item(current_quests[i])
		set_item_custom_bg_color(next_quests.size()+i, Color(0.2,0.2,0.2))
		set_item_custom_fg_color(next_quests.size()+i, Color(0.4,0.4,0.4))
		under_array.push_back(current_quests[i])


func _on_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var selected_quests : String = under_array[index]
	Signals.display_quest_data.emit(QuestData.side_quests[selected_quests])
