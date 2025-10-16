extends CanvasLayer

@onready var map_image = $MapImage

func show_map():
	map_image.visible = true

func hide_map():
	map_image.visible = false

func _input(event: InputEvent):
	if event.is_action_pressed("show_map"):
		show_map()
		print("a")
	elif event.is_action_released("show_map"):
		hide_map()
