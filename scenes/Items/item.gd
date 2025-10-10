class_name Item
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var max_stack_size: int = 1
@export var consumable: bool = false

func _on_use(user: Node) -> bool:
	if consumable:
		print("%s used by %s" % [name, user.name])
		return true
	else:
		print("%s activated by %s" % [name, user.name])
		return false
