extends BasicEnemy

func _ready() -> void:
	health = 10.0
	moveSpeed = 20.0
	detectionRadius = 100000.0
	sightRadius = detectionRadius
	damage = 24.0
	scale.x = 3.0
	scale.y = scale.x

func die() -> void:
	
	#kill bodyparts
	for node in get_children():
		if node is Bodypart:
			node.die()
	
	#kill self
	health = 0.0
	state = State.DEAD
	set_collision_layer_value(2, false)
	set_collision_layer_value(1, false)
	velocity = Vector2.ZERO
	sprite.rotation = deg_to_rad(180-rotation)
	
	EventManager.trigger_boss_dead()
