extends Node

@onready var area = $Area2D
@onready var sprite = $Sprite2D
@export var type: ItemType
@export var quantity: int
@onready var item: Item

enum ItemType {MEDKIT, BULLET, CLUE}

const ITEM_TYPE := {
	ItemType.MEDKIT: preload("res://scenes/Items/medkit.tres"),
	ItemType.BULLET: preload("res://scenes/Items/bullet_item.tres"),
	ItemType.CLUE: preload("res://scenes/Items/clue.tres")
}

func _ready():
	item = ITEM_TYPE.get(type)
	sprite.texture = item.icon
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		EventManager.trigger_item_pickedup(item, quantity)
		queue_free()
