extends Item

@export var heal_amount: int = 25

func _on_use() -> bool:
	if true:
		owner.heal(heal_amount)
		print("user healed")
		return true
	else:
		print("failed to use medkit")
		return false
