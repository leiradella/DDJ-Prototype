extends Area2D

@export var gun_name: String = "Pistol"

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node):
	if body.is_in_group("Player"):
		# Send signal to EventManager so player knows they picked up the gun
		EventManager.get_gun.emit()
		queue_free()  # remove pickup from the world
