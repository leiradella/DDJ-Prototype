class_name Player
extends CharacterBody2D

var moveSpeed: float = 400.0
var health: float = 40.0

@onready var gun: Node = $Gun

func _ready() -> void:
	#needed so the enemy can have a reference for the player
	add_to_group("Player")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	up_direction = Vector2.ZERO            # disables floor/ceiling logic
	floor_stop_on_slope = false

func handle_movement_input() -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * moveSpeed
	else:
		velocity = Vector2.ZERO

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
	#check mouse input
	if event is InputEventMouseButton:
		handle_mouse_button(event)
	
	#check keyboard
	if Input.is_action_just_pressed("reload"):
		if gun != null and not gun.is_reloading:
			gun.reload()

func takeDamage(damage: float) -> void:
	health -= damage
	print(health)
	#TODO: die

func heal(amount: float):
	print(health)
	health += amount
	print(health)
	#TODO: add clamp or something
