extends Node

@onready var inventory = $Inventory

var bullet_item = preload("res://scenes/Items/bullet_item.tres")
var player: Player

func _ready():
	EventManager.item_pickedup.connect(_on_receive_item)
	player = get_parent()
	
func _on_receive_item(item, quantity):
	item.owner = player
	inventory.on_give_player_item(item, quantity)
	
func reload_gun(amount) -> int:
	var current = inventory.get_number_of_item(bullet_item)
	if current > 0:
		if current >= amount:
			inventory.on_remove_player_item(bullet_item, amount)
			return amount
		else:
			inventory.on_remove_player_item(bullet_item, current)
			return current
	else:
		return 0
