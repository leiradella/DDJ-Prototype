extends Node

@export var pause_menu_packed : PackedScene
@export var focused_viewport : Viewport

var pause_layer : CanvasLayer

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_open_pause_menu()

func _open_pause_menu() -> void:
	if not focused_viewport:
		focused_viewport = get_viewport()

	var _initial_focus_control = focused_viewport.gui_get_focus_owner()
	var current_menu = pause_menu_packed.instantiate()

	# ✅ Créer un CanvasLayer qui contiendra le menu
	pause_layer = CanvasLayer.new()
	pause_layer.add_child(current_menu)
	get_tree().root.call_deferred("add_child", pause_layer)

	# ✅ Connecter la fermeture automatique quand on quitte la scène
	get_tree().current_scene.tree_exiting.connect(_close_pause_menu)

	await current_menu.tree_exited
	_close_pause_menu()

	if is_inside_tree() and _initial_focus_control:
		_initial_focus_control.grab_focus()

func _close_pause_menu() -> void:
	if pause_layer and pause_layer.is_inside_tree():
		pause_layer.queue_free()
		pause_layer = null
