extends Item

@export var heal_amount: int = 25

func _on_use(user: Node) -> bool:
	if user.has_method("heal"):
		user.heal(heal_amount)
		print("Healed %s for %d HP" % [user.name, heal_amount])
		return true
	else:
		print("failed to use medkit")
		return false
