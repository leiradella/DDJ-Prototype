extends Node2D
@export var map_position: Vector2 = Vector2(1790,444)
func _ready() -> void:
	var map = get_node("/root/WorldMapOverlay")
	if map:
		map.set_player_room(self.map_position)
	self.y_sort_enabled = true
	InputManager.set_control_mode(InputManager.ControlMode.GAMEPLAY)
	GlobalPlayerManager.set_as_parent(self)
	EventManager.level_load_started.connect( _free_level )
	
	
func _free_level()-> void:
	GlobalPlayerManager.unparent_player(self)
	queue_free()
