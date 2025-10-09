extends Node

signal item_pickedup(item, quantity)

func trigger_item_pickedup(item, quantity):
	emit_signal("item_pickedup", [item, quantity])
