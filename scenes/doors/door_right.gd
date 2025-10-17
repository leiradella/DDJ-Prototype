extends Node2D
@onready var sprite = $Sprite2D

func _ready() -> void:
	sprite.play("stop")
	EventManager.puzzle_solved.connect(_on_door_open)
	pass

func _on_door_open() -> void:
	sprite.play("moving")
	queue_free()
