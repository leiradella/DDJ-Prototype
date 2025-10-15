extends Node
const PLAYER =preload("res://scenes/Player/Player.tscn")

var player:Player

func _ready() -> void:
	add_player_instance()


func add_player_instance()-> void:
	player = PLAYER.instantiate()
	add_child(player)
	pass

func unparent_player( _p :Node2D)->void:
	_p.remove_child(player)
	
func set_as_parent( _p : Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_p.add_child(player)

func set_player_position(_new_pos : Vector2)-> void:
	player.global_position = _new_pos
