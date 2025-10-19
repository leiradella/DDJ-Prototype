extends CanvasLayer

@onready var map_image: TextureRect = $MapImage
@onready var player_marker: Node2D = $Sprite2D

var current_room_pos: Vector2 = Vector2.ZERO

func set_player_room(room_map_pos: Vector2) -> void:
	current_room_pos = room_map_pos
	update_player_marker()

func show_map():
	map_image.visible = true
	player_marker.visible = true
	update_player_marker()

func hide_map():
	map_image.visible = false
	player_marker.visible = false

func _input(event: InputEvent):
	if event.is_action_pressed("show_map"):
		show_map()
	elif event.is_action_released("show_map"):
		hide_map()

func update_player_marker():
	player_marker.position = current_room_pos
