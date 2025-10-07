extends Node

@onready var label = $dalabel
@onready var circle1 = $RigidBody2D2
@onready var circle2 = $RigidBody2D

func _ready():
	circle1.bounced.connect(func(new_hp): _on_bounced(new_hp, 1))
	circle2.bounced.connect(func(new_hp): _on_bounced(new_hp, 2))

var hp = 0
var boss_hp = 0

func _on_bounced(new_hp, id):
	if id == 1:
		hp = new_hp
	elif id == 2:
		boss_hp = new_hp
	label.text = "HP: %d   Boss HP: %d" % [hp, boss_hp]
