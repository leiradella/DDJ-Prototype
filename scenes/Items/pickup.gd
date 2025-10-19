extends Node

@onready var area = $Area2D
@onready var sprite = $Sprite2D
@onready var item: Item

@export var type: ItemType
@export var quantity: int


enum ItemType {MEDKIT, BULLET, FIRST_CLUE, SECOND_CLUE, THIRD_CLUE}

const ITEM_TYPE := {
	ItemType.MEDKIT: preload("res://scenes/Items/medkit.tres"),
	ItemType.BULLET: preload("res://scenes/Items/bullet_item.tres"),
	ItemType.FIRST_CLUE: preload("res://scenes/Items/clueFirst.tres"),
	ItemType.SECOND_CLUE: preload("res://scenes/Items/clueSecond.tres"),
	ItemType.THIRD_CLUE: preload("res://scenes/Items/clueThird.tres")
}

func _ready():
	item = ITEM_TYPE.get(type)
	sprite.texture = item.icon
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		EventManager.trigger_item_pickedup(item, quantity)
		queue_free()
