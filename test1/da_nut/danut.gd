extends RigidBody2D

@export var bounces: int = 6
@export var reacts_to_button: bool = false
@onready var label = $Label

signal bounced(new_hp)

func _ready():
	update_label()
	if reacts_to_button:
		var da_button = get_parent().get_node("Button")
		da_button.pressed.connect(func(): _on_button_press())

func update_label():
	label.text = str(bounces)

func _on_area_2d_body_entered(body: Node2D) -> void:
	bounces -= 1
	update_label()
	emit_signal("bounced", bounces)
	if bounces <= 0:
		queue_free()

func _on_button_press():
	bounces += 1
	update_label()
	emit_signal("bounced", bounces)
