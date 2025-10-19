extends Resource
class_name LevelState
@export var color : Color
@export var tutorial_read : bool = false
@export var collected_items: Dictionary =  { 
"gun_room3": false, 
"puzzle_room8": false, 
"puzzle_corredor2": false, 
"room1_medkit": false,
"room2_clue1": false,
"room3_bullets": false,
"room4_bullets": false,
"room5_clue2": false,
"room6_medkit": false,
"room7_clue3": false,
"special_room_bullets":false,
"special_room_medkits": false }

func mark_item_collected(item_id: String) -> void:
	collected_items[item_id] = true

func is_item_collected(item_id: String) -> bool:
	return collected_items.has(item_id) and collected_items[item_id]

func mark_item_uncollected(item_id: String) -> void:
	collected_items[item_id] = false
