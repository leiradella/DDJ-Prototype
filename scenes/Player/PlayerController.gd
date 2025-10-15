class_name Player
extends CharacterBody2D

signal interact(entity)
signal stop_interact(entity)
var player:Player
var moveSpeed: float = 60.0
var health: float = 40.0

@onready var gun: Node = $Sprite2D/Gun
@onready var inventoryManager = $InventoryManager
var can_update :int = 1
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D 

func _ready() -> void:
	#needed so the enemy can have a reference for the player
	add_to_group("Player")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	floor_stop_on_slope = false

func handle_movement_input() -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * moveSpeed
		if direction.x > 0 && can_update != 1:
			update_animation(1)
			can_update=1
			sprite.scale.x =0.2
		elif direction.x < 0 && can_update != 2:
			update_animation(2)
			can_update = 2
			sprite.scale.x =-0.2
	else:
		velocity = Vector2.ZERO
		if can_update != 0:
			update_animation(0)
			can_update = 0

func _physics_process(_delta: float) -> void:
	if not InputManager.is_mode_gameplay():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	handle_movement_input()
	move_and_slide()

func handle_mouse_button(event: InputEvent) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			#shoot the gun
			if gun != null:
				if not gun.is_reloading:
					gun.shoot()
				else:
					gun.reload_interrupted = true

func _input(event: InputEvent) -> void:
	if InputManager.currentMode == InputManager.ControlMode.INTERACTING:
		if Input.is_action_just_pressed("escape"):
			emit_signal("stop_interact", self)
		return
	
	#check mouse input
	if event is InputEventMouseButton:
		handle_mouse_button(event)
	
	#check keyboard
	if Input.is_action_just_pressed("reload"):
		if gun != null and not gun.is_reloading:
			if gun.MAG_SIZE - gun.mag != 0:
				gun.reload(inventoryManager.reload_gun(gun.MAG_SIZE - gun.mag))
	if Input.is_action_just_pressed("interact"):
		emit_signal("interact", self)

func takeDamage(damage: float) -> void:
	health -= damage
	print(health)
	#TODO: die

func heal(amount: float):
	print(health)
	health += amount
	print(health)
	#TODO: add clamp or something

func update_animation(_dir : int) -> void :
	if _dir ==0:
		animation_player.play("idle_down")
	elif _dir == 1 or _dir ==2:
		animation_player.play("idle_walk")
	pass
