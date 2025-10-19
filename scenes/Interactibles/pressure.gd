extends Node2D

var overlapping_bodies: Array[Node2D] = []

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" || body.name == "Pushable":
		if overlapping_bodies.is_empty():
			EventManager.trigger_pressure_on()
			var level_key = get_tree().current_scene.scene_file_path
			var level_state = GameState.get_level_state(level_key)
			if level_state:
				level_state.mark_item_collected("puzzle_corredor2")
				GlobalState.save()
		overlapping_bodies.append(body)
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player" || body.name == "Pushable":
		overlapping_bodies.erase(body)
		if overlapping_bodies.is_empty() and get_tree().current_scene.has_node("Player"):
			EventManager.trigger_pressure_off()
			var level_key = get_tree().current_scene.scene_file_path
			var level_state = GameState.get_level_state(level_key)
			if level_state:
				level_state.mark_item_uncollected("puzzle_corredor2")
				GlobalState.save()
