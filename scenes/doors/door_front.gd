extends StaticBody2D
@onready var sprite = $Sprite2D
@onready var collision : CollisionShape2D = $CollisionShape2D
@export var item_id: String = "puzzle_room8"

func _ready() -> void:
	var level_key = get_tree().current_scene.scene_file_path
	var level_state = GameState.get_level_state(level_key)
	if level_state and level_state.is_item_collected(item_id):
		_on_door_open()
		return
	sprite.play("stop")
	EventManager.puzzle_solved.connect(_on_door_open)
	EventManager.pressure_on.connect(_on_door_open)
	EventManager.pressure_off.connect(_on_door_close)

func _on_door_open() -> void:
	sprite.play("moving")
	collision.set_deferred("disabled", true)

func _on_door_close() -> void:
	sprite.play_backwards("moving")
	collision.set_deferred("disabled", false)
