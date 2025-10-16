class_name Interactible
extends Node2D

var prompt_text: String = "Interact"
var can_interact: bool = true
@onready var area: Area2D = get_node("InteractionArea")

var player: Node = null

func _ready() -> void:
	add_to_group("Interactible")
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player = body
		focus(player)

func _on_body_exited(body: Node) -> void:
	if body == player:
		unfocus(player)
		player = null

func _on_interact(entity: Node) -> void:
	if not can_interact:
		return
	
	print("Base interactible used by:", entity)

func _on_stop_interact(_entity) -> void:
	print("Stopped interacting")

func focus(entity: Node) -> void:
	entity.interact.connect(_on_interact)
	entity.stop_interact.connect(_on_stop_interact)

func unfocus(entity: Node) -> void:
	entity.interact.disconnect(_on_interact)
	entity.stop_interact.disconnect(_on_stop_interact)
