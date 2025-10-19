class_name Bodypart
extends StaticBody2D

@onready var hitbox: CollisionShape2D = $hitbox
@onready var take_dmg_sound: AudioStreamPlayer = $take_dmg_sound

@export var main_body: CharacterBody2D
@export var max_health: float
var RDR: float = 1.1 #repeatedDamageReducion, part of the EATS system
var RDR_growth_rate: float = 1.1

var health: float

func _ready() -> void:
	health = max_health

func take_damage(dmg: float) -> void:
	take_dmg_sound.play()
	health -= dmg - (dmg*(RDR-1))
	RDR *= RDR_growth_rate

func die() -> void:
	health = 0.0
	set_collision_layer_value(5, false)

func revive() -> void:
	health = max_health
	set_collision_layer_value(5, true)
