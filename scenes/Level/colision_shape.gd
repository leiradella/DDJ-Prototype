@tool
extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file("*.tscn") var level
@export var target_transition_area : String = "LevelTransition"

@export_category("Colision Area Settings")

@export_range(1, 12, 1, "or_greater") var size : int = 1 :
	set( value ):
		size = value
		_update_area()

@export var side: SIDE = SIDE.LEFT

@onready var colision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
		
	monitoring = false
	_place_player()
	
	await EventManager.level_loaded
	monitoring = true
	body_entered.connect(_player_entered)

func _update_area() -> void:
	var new_rect : Vector2 = Vector2( 32,32)
	var new_position : Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
	
	if colision_shape == null:
		colision_shape =get_node("CollisionShape2D")
		
	colision_shape.shape.size = new_rect
	colision_shape.position = new_position


func _player_entered(_p : Node2D) -> void:
	EventManager.load_new_level( level, target_transition_area, Vector2.ZERO)

func _place_player() -> void:
	if name != EventManager.target_transition:
		return
	GlobalPlayerManager.set_player_position(Vector2.ZERO)	

func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = GlobalPlayerManager.player.global_position
	
	if side == SIDE.LEFT or side ==SIDE.RIGHT:
		offset.y = player_pos.y - global_position.y
		offset.x = 16
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x - global_position.x
		offset.y = 16
		if side == SIDE.LEFT:
			offset.y *= -1
	
	return offset
