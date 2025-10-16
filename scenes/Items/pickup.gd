extends Node

@onready var label = $Node2D/Label
@onready var area = $Node2D/Area2D

@export var type: ItemType
@export var quantity: int
@onready var item: Item

enum ItemType {MEDKIT, BULLET}

const ITEM_RESOURCES := {
	ItemType.MEDKIT: preload("res://scenes/Items/medkit.tres"),
	ItemType.BULLET: preload("res://scenes/Items/bullet_item.tres")
}

func _ready():
	item = ITEM_RESOURCES.get(type)
	label.text = str(item.name)
	$Node2D.position = Vector2(randi() % 1920, randi() % 1080)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		EventManager.trigger_item_pickedup(item, quantity)
		queue_free()
