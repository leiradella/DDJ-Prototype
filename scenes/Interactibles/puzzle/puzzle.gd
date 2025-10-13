extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var rich_text_label: RichTextLabel = $CanvasLayer/RichTextLabel
@onready var line_edit: LineEdit = $CanvasLayer/LineEdit

var max_text_size: int = 14

func _ready() -> void:
	canvas_layer.hide()
	line_edit.text_changed.connect(_on_text_edited)

func start() -> void:
	canvas_layer.show()

func end() -> void:
	canvas_layer.hide()

func _on_text_edited(_new_text: String) -> void:
	if line_edit.text.length() > max_text_size:
		line_edit.text = line_edit.text.substr(0, max_text_size)
		line_edit.set_caret_column(line_edit.text.length())
	
	if line_edit.text == "solution":
		print("solved!!!!")
		rich_text_label.text = "[color=green]PASSWORD:[/color]"
		line_edit.editable = false
		EventManager.trigger_puzzle_solved()
