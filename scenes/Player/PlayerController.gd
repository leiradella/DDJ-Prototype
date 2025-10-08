extends CharacterBody2D

@export var moveSpeed: float = 100.0

@onready var gun: Node = $Gun

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
				gun.shoot()

func _input(event: InputEvent) -> void:
	#check mouse input
	if event is InputEventMouseButton:
		handle_mouse_button(event)
	
	#check keyboard
	if Input.is_action_just_pressed("reload"):
		if gun != null:
			gun.reload()
