extends Button

func _pressed():
	print("Exit pressé !")  # Debug

	# On remonte jusqu'au CanvasLayer parent
	var node = self
	while node and not (node is CanvasLayer):
		node = node.get_parent()

	if node:
		print("CanvasLayer trouvé : ", node)
		node.get_tree().paused = false
		node.queue_free()
	else:
		print("Pas trouvé le CanvasLayer parent !")
