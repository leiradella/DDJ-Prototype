@tool
class_name CreditsMenuContainer
extends OverlaidMenu

@export var menu_scene: PackedScene:
	set(value):
		var _value_changed = menu_scene != value
		menu_scene = value
		if _value_changed:
			_load_menu()

func _ready():
	_load_menu()

func _load_menu():
	var panel = find_child("Panel", true, false)
	if panel:
		for child in panel.get_children():
			child.queue_free()
		if menu_scene:
			var instance = menu_scene.instantiate()
			panel.add_child(instance)
	else:
		push_error("⚠ Aucun node 'Panel' trouvé dans la scène Credits !")
