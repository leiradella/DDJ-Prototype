extends Node2D
@export var item_id: String = "puzzle_corredor2"

func _ready() -> void:
	var level_key = get_tree().current_scene.scene_file_path
	var level_state = GameState.get_level_state(level_key)
	print(level_state.is_item_collected(item_id))
	if level_state and level_state.is_item_collected(item_id):
		position = Vector2(65,-129)
