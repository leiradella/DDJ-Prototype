extends Node

signal item_pickedup(item, quantity)
signal puzzle_solved

func trigger_item_pickedup(item, quantity):
	emit_signal("item_pickedup", item, quantity)

func trigger_puzzle_solved() -> void:
	emit_signal("puzzle_solved")
