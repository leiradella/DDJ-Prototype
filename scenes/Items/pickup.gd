extends RigidBody2D

@export var type: ItemType
@export var quantity: int
@onready var label = $Label
@onready var item: Item

enum ItemType {MEDKIT, BULLET}

const ITEM_RESOURCES := {
	ItemType.MEDKIT: preload("res://scenes/Items/medkit.tres"),
	#ItemType.BULLET: preload("res://inventory/bullet.tres")
}

func _ready():
	item = ITEM_RESOURCES.get(type)
	label.text = str(item.name)
	global_position = Vector2(randi() % 1920, randi() % 1080)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("test")
	EventManager.trigger_item_pickedup(item, quantity)
	queue_free()
	
	
