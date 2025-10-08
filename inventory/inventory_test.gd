extends Node

@onready var inventory = $Inventory
@onready var button_add_medkit = $ButtonAdd
@onready var button_remove_medkit = $ButtonRemove
@onready var label = $Label

var medkit_item = preload("res://inventory/medkit.tres")

func _ready():
	button_add_medkit.text = "Add medkit"
	button_remove_medkit.text = "Remove medkit"
	label.text = "Press I for inventory"

	button_add_medkit.pressed.connect(_on_add_medkit_pressed)
	button_remove_medkit.pressed.connect(_on_remove_medkit_pressed)

func _on_add_medkit_pressed():
	inventory.on_give_player_item(medkit_item, 1)

func _on_remove_medkit_pressed():
	inventory.remove_item(medkit_item)
