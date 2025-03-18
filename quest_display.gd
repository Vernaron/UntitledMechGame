extends Panel
var current_quest : QuestData.Quest = null
var mapImages : Dictionary = {
	Arena.localeNames.tundra: preload("res://icon.svg")
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.display_quest_data.connect(display_quest)

func display_quest(quest:QuestData.Quest)->void:
	current_quest = quest
	$Description.text = quest.description
	$MapImage.texture = mapImages[quest.map]
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_button_pressed() -> void:
	if current_quest!=null:
		PlayerInfo.active_quest = current_quest
		Signals.start_combat_area.emit(current_quest.map)
