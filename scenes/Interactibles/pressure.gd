extends Node

var greg = preload("res://assets/greg_circ.png")
var red = preload("res://assets/red_circ.png")

var overlapping_bodies: Array[Node2D] = []

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" || body.name == "Pushable":
		if overlapping_bodies.is_empty():
			EventManager.trigger_pressure_on()
			$Sprite2D.texture = greg
		overlapping_bodies.append(body)
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player" || body.name == "Pushable":
		overlapping_bodies.erase(body)
		if overlapping_bodies.is_empty():
			EventManager.trigger_pressure_off()
			$Sprite2D.texture = red
