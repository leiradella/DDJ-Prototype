extends Node

signal item_pickedup(item, quantity)
signal puzzle_solved
signal pressure_on
signal pressure_off
signal level_load_started
signal level_loaded
var target_transition : String
var position_offset : Vector2

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func trigger_item_pickedup(item, quantity):
	emit_signal("item_pickedup", item, quantity)

func trigger_puzzle_solved() -> void:
	emit_signal("puzzle_solved")
	
func trigger_pressure_on():
	emit_signal("pressure_on")
	
func trigger_pressure_off():
	emit_signal("pressure_off")

func load_new_level(level_path : String, _target_transition : String, _position_offset : Vector2) -> void:
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await get_tree().process_frame
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file(level_path)
	
	await get_tree().process_frame
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
