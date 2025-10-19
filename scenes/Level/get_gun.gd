extends Area2D
@export var item_id: String = "gun_room3"

func _ready():
	var level_key = get_tree().current_scene.scene_file_path
	var level_state = GameState.get_level_state(level_key)
	if level_state and level_state.is_item_collected(item_id):
		queue_free()
		return
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node):
	if body.is_in_group("Player"):
		# mark item as collected
		var level_key = get_tree().current_scene.scene_file_path
		var level_state = GameState.get_level_state(level_key)
		if level_state:
			level_state.mark_item_collected(item_id)
			GlobalState.save()  # persist immediately
		
		EventManager.get_gun.emit()
		queue_free()
