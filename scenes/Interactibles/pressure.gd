extends Node

var greg = preload("res://assets/greg_circ.png")
var red = preload("res://assets/red_circ.png")

var overlapping_bodies: Array[Node2D] = []

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" || body.name == "Pushable":
		overlapping_bodies.append(body)
		$Sprite2D.texture = greg
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player" || body.name == "Pushable":
		overlapping_bodies.erase(body)
		if overlapping_bodies.is_empty():
			print("Button released")
			$Sprite2D.texture = red
