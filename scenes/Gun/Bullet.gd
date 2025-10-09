extends Area2D

var speed: float = 0
var direction: Vector2 = Vector2.ZERO
var damage: float = 1.0

func _ready() -> void:
	#connect the signal
	connect("body_entered", _on_body_entered)
	speed = 550.0
	damage = 1.0
	return

func _on_body_entered(body) -> void:
	if body.is_in_group("Enemies"):
		body.TakeDamage(damage)
	queue_free()
	return

func _process(delta):
	position += direction * speed * delta
	return
