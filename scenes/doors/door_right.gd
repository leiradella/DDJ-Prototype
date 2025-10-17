extends StaticBody2D
@onready var sprite = $Sprite2D
@onready var collision : CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	sprite.play("stop")
	EventManager.puzzle_solved.connect(_on_door_open)
	EventManager.pressure_on.connect(_on_door_open)
	EventManager.pressure_off.connect(_on_door_close)
	pass

func _on_door_open() -> void:
	sprite.play("moving")
	collision.set_deferred("disabled", true)

func _on_door_close() -> void:
	sprite.play_backwards("moving")
	collision.set_deferred("disabled", false)
