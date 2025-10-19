extends StaticBody2D
@onready var sprite = $Sprite2D
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var door_open_sound: AudioStreamPlayer = $door_open_sound

func _ready() -> void:
	sprite.play("stop")
	EventManager.boss_dead.connect(_on_door_open)

func _on_door_open() -> void:
	door_open_sound.play()
	sprite.play("moving")
	collision.set_deferred("disabled", true)
