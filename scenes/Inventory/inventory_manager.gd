extends Node

@onready var inventory = $Inventory

var medkit_item = preload("res://scenes/Items/medkit.tres")
var player: Player

func _ready():
	EventManager.item_pickedup.connect(_on_receive_item)
	player = get_parent()
	
func _on_receive_item(item, quantity):
	item.owner = player
	inventory.on_give_player_item(item, quantity)
	
func _on_add_medkit():
	inventory.on_give_player_item(medkit_item, 1)

func _on_remove_medkit():
	inventory.remove_item(medkit_item)
