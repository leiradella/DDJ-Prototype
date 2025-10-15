extends Node2D
func _ready() -> void:
	self.y_sort_enabled = true
	InputManager.set_control_mode(InputManager.ControlMode.GAMEPLAY)
	GlobalPlayerManager.set_as_parent(self)
	EventManager.level_load_started.connect( _free_level )
	
	
func _free_level()-> void:
	GlobalPlayerManager.unparent_player(self)
	queue_free()
