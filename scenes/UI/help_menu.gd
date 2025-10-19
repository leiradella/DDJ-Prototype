extends CanvasLayer

func _ready():
	visible = true  # Menu visible quand il apparaît

func close_help_menu():
	get_tree().paused = false
	queue_free()
