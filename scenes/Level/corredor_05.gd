extends Node2D

func _ready() -> void:
	InputManager.set_control_mode(InputManager.ControlMode.GAMEPLAY)
	EventManager.level_load_started.connect(_on_level_exit)
	
	# Take control of the player from the GlobalPlayerManager and add it to this scene.
	GlobalPlayerManager.reparent_player(self)

func _on_level_exit() -> void:
	# Before this level is destroyed, give the player back to the GlobalPlayerManager
	# so it persists through the scene change.
	GlobalPlayerManager.reparent_player(GlobalPlayerManager)
	queue_free()
