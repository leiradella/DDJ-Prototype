class_name Item
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var max_stack_size: int = 1
@export var consumable: bool = false
var owner: Player

func _on_use() -> bool:
	if consumable:
		#print("%s used by %s" % [name, owner])
		return true
	else:
		#print("%s activated by %s" % [name, owner])
		return false
