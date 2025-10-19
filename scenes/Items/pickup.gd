extends Node

@onready var area = $Area2D
@onready var sprite = $Sprite2D
@onready var item: Item

@export var type: ItemType
@export var quantity: int
@export var item_id : String = ""

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
	var level_key = get_tree().current_scene.scene_file_path
	var level_state = GameState.get_level_state(level_key)
	if level_state and level_state.is_item_collected(item_id):
		queue_free()
		return
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var level_key = get_tree().current_scene.scene_file_path
		var level_state = GameState.get_level_state(level_key)
		if level_state:
			level_state.mark_item_collected(item_id)
			GlobalState.save()
		EventManager.trigger_item_pickedup(item, quantity)
		queue_free()
