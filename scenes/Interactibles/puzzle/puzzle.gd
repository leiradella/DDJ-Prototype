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
	
	if line_edit.text == "corruption":
		print("solved!!!!")
		rich_text_label.text = "[color=green]PASSWORD:[/color]"
		line_edit.editable = false
		var level_key = get_tree().current_scene.scene_file_path
		var level_state = GameState.get_level_state(level_key)
		if level_state:
			level_state.mark_item_collected("puzzle_room8")
			GlobalState.save() 
		EventManager.trigger_puzzle_solved()
