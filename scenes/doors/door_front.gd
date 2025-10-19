extends StaticBody2D
@onready var sprite = $Sprite2D
@onready var collision : CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	sprite.play("stop")
	EventManager.boss_dead.connect(_on_door_open)

func _on_door_open() -> void:
	sprite.play("moving")
	collision.set_deferred("disabled", true)
