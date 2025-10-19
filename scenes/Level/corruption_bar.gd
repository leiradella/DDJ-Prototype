extends ProgressBar
class_name CorruptionBar

@export var decrease_amount: int = 10
@export var min_value_allowed: int = 0

func _ready() -> void:
	max_value = 100

	EventManager.puzzle_solved.connect(_on_puzzle_solved)

func _on_puzzle_solved() -> void:
	var new_value = max(value - decrease_amount, min_value_allowed)
	var tween = create_tween()
	tween.tween_property(self, "value", new_value, 0.4)
	print("Puzzle solved → corruption reduce to :", new_value)

func getcorruption_level()->float:
	return value
