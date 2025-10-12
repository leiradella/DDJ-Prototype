extends Interactible

func _on_interact(_entity: Node) -> void:
	if not can_interact:
		return
	
	print("Computer interacted")
	can_interact = false
	await get_tree().create_timer(2.0).timeout
	can_interact = true
