extends Resource
class_name LevelState
@export var color : Color
@export var tutorial_read : bool = false
@export var collected_items: Dictionary =  { "gun_room3": true }

func mark_item_collected(item_id: String) -> void:
	collected_items[item_id] = true

func is_item_collected(item_id: String) -> bool:
	return collected_items.has(item_id) and collected_items[item_id]
