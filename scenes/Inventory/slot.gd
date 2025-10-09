class_name InventorySlot
extends Node

@onready var icon : TextureRect = get_node("Icon")
@onready var quantity_text : Label = get_node("Quantity")

var item : Item
var quantity : int
var inventory : Inventory

func _ready():
	connect("pressed", Callable(self, "_on_pressed"))
	connect("mouse_entered", Callable(self, "_on_hover_enter"))
	connect("mouse_exited", Callable(self, "_on_hover_exit"))

func set_item (new_item : Item):
	item = new_item
	if item == null:
		quantity = 0
		icon.visible = false
	else:
		quantity = 1
		icon.visible = true
		icon.texture = item.icon
	update_quantity_text()

func add_item ():
	quantity += 1
	update_quantity_text()

func remove_item ():
	quantity -= 1
	update_quantity_text()
	if quantity == 0:
		set_item(null)

func update_quantity_text ():
	if quantity == 0:
		quantity_text.text = ""
	else:
		quantity_text.text = str(quantity)

func _on_pressed():
	if item == null:
		return
	var remove_after_use = item._on_use(inventory.get_parent())
	if remove_after_use:
		remove_item()

func _on_hover_enter():
	if item != null:
		inventory.update_info_label(item)

func _on_hover_exit():
	inventory.update_info_label(null)
