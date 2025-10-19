extends Button

@export var help_menu_packed: PackedScene
var help_instance: Node

func _pressed() -> void:
	if help_instance:
		return  # Pour éviter d’en ouvrir plusieurs

	# Instancier le menu
	help_instance = help_menu_packed.instantiate()

	# Ajouter à la racine pour être toujours au-dessus
	get_tree().root.add_child(help_instance)

	# Optionnel : s'assurer qu'il est devant
	if help_instance.has_method("move_to_front"):
		help_instance.move_to_front()
