extends Interactible

@onready var puzzle: Control = $Puzzle

func _on_interact(_entity: Node) -> void:
	if not can_interact:
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
