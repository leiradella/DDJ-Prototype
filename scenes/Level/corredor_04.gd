extends Node2D

func _ready() -> void:
	InputManager.set_control_mode(InputManager.ControlMode.GAMEPLAY)
	EventManager.level_load_started.connect( _free_level )
func _free_level()-> void:
	GlobalPlayerManager.unparent_player(self)
	queue_free()
