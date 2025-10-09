class_name Inventory
extends Node
var slots : Array[InventorySlot]
@onready var window : Panel = get_node("Window")
@onready var info_text : Label = get_node("Window/Info")
@export var starter_items : Array[Item]

func _ready ():
	toggle_window(false)
	
	for child in get_node("Window/SlotGridContainer").get_children():
		slots.append(child)
		child.set_item(null)
		child.inventory = self
		
	for item in starter_items:
		add_item(item)
	
func _process (_delta):
	if Input.is_action_just_pressed("inventory"):
		toggle_window(!window.visible)

func toggle_window (open : bool):
	window.visible = open
#	if open:
#		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#	else:
#		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func on_give_player_item (item : Item, amount : int):
	for i in range(amount):
		add_item(item)

func add_item (item : Item):
	var slot = get_slot_to_add(item)
	if slot == null:
		return
	if slot.item == null:
		slot.set_item(item)
	elif slot.item == item:
		slot.add_item()

func remove_item (item : Item):
	var slot = get_slot_to_remove(item)
	if slot == null or slot.item != item:
		return
	slot.remove_item()

func get_slot_to_add (item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item and slot.quantity < item.max_stack_size:
			return slot
	for slot in slots:
		if slot.item == null:
			return slot
	return null

func get_slot_to_remove (item : Item) -> InventorySlot:
	var temp_slot: InventorySlot = null
	for slot in slots:
		if slot.item == item:
			if slot.quantity < item.max_stack_size:
				return slot
			if temp_slot == null:
				temp_slot = slot
	return temp_slot

func get_number_of_item (item : Item) -> int:
	var total = 0
	for slot in slots:
		if slot.item == item:
			total += slot.quantity
	return total
	
func update_info_label (item : Item):
	if item == null:
		info_text.text = "Hover item for info"
	else:
		info_text.text = item.description
