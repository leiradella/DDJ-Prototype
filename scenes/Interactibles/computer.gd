extends Interactible

@onready var puzzle: Control = $Puzzle
@export var item_id: String = "puzzle_room8"

func _on_interact(_entity: Node) -> void:
	var level_key = get_tree().current_scene.scene_file_path
	var level_state = GameState.get_level_state(level_key)
	if (not can_interact) or (level_state and level_state.is_item_collected(item_id)):
		return
	
	InputManager.set_control_mode(InputManager.ControlMode.INTERACTING)
	start_minigame()
	
	can_interact = false
	await get_tree().create_timer(2.0).timeout
	can_interact = true

func _on_stop_interact(_entity) -> void:
	InputManager.set_control_mode(InputManager.ControlMode.GAMEPLAY)
	puzzle.end()

func start_minigame() -> void:
	puzzle.start()
