extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

#enemy stats
var health: float = 3.0
var moveSpeed: float = 20.0
var detectionRadius: float = 100.0
var sightRadius: float = 200.0
var reviveRange: float = 30.0
var reviveTime: float = 2.0
var timer: float = 0.0
var last_facing: Vector2 = Vector2.DOWN
var facing_deadzone: float = 0.1

#ressurrection target
var target: Node2D = null

enum State {
	IDLE,
	FLIGHT,
	REVIVE,
	DEAD
}
var state: State = State.IDLE
var player: Node2D #player reference
var enemies: Array[Node]
var reviveTarget: Node

func _ready() -> void:
	add_to_group("Enemies")
	sprite.play("idle_down")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	up_direction = Vector2.ZERO
	floor_stop_on_slope = false
	
	enemies = get_tree().get_nodes_in_group("EnemyBasic")
	
	scan_for_player()

func _physics_process(delta: float) -> void:
	if player == null:
		scan_for_player()
		return
	
	
	match state:
		State.IDLE:
			_idle_update(delta)
		State.FLIGHT:
			_flight_update(delta)
		State.REVIVE:
			_revive_update(delta)
		State.DEAD:
			_dead_update(delta)
		_:
			pass
	
	update_animation()
	move_and_slide()

func _idle_update(_delta: float) -> void:
	velocity = Vector2.ZERO
	var distance: float = position.distance_to(player.position)
	if distance < detectionRadius:
		state = State.FLIGHT
		return
	
	DetectDead()

func _flight_update(_delta: float) -> void:
	var direction: Vector2 = player.global_position - global_position
	
	if direction.length() > sightRadius:
		state = State.IDLE
		return
	
	direction = direction.normalized()
	velocity = -direction * moveSpeed

func _revive_update(delta: float) -> void:
	var targetDirection: Vector2 = target.global_position - global_position
	var playerDistance: float = global_position.distance_to(player.global_position)
	
	if playerDistance < detectionRadius:
		state = State.FLIGHT
		return
	
	if targetDirection.length() < reviveRange:
		velocity = Vector2.ZERO
		
		timer -= delta
		if timer <= 0.0:
			target.revive()
			state = State.IDLE
		return
	
	targetDirection = targetDirection.normalized()
	velocity = targetDirection * moveSpeed

func _dead_update(_delta: float) -> void:
	pass

func take_damage(bodypart: Bodypart, dmg: float) -> void:
	
	bodypart.take_damage(dmg)
	if bodypart.health <= 0.0:
		die()
		return
	
	health -= dmg
	if health <= 0:
		die()
		return

func die() -> void:
	
	#kill bodyparts
	for node in get_children():
		if node is Bodypart:
			node.die()
	
	#kill self
	health = 0.0
	state = State.DEAD
	set_collision_layer_value(2, false)
	velocity = Vector2.ZERO
	sprite.rotation = deg_to_rad(180-rotation)

func DetectDead() -> void:
	var enemyDistance: float = -1.0
	#loop throught the enemies and find the dead ones, then choose the nearest dead enemy
	for enemy in enemies:
		if enemy.IsDead():
			var new_distance: float = global_position.distance_to(enemy.global_position)
			if new_distance < enemyDistance or enemyDistance < 0.0:
				enemyDistance = new_distance
				target = enemy
	
	#if an enemy was found then begin ressurection
	if enemyDistance != -1.0 and target != null:
		print("state = revive")
		print("distance = ", enemyDistance)
		print("target = ", target)
		timer = reviveTime
		state = State.REVIVE

func update_animation() -> void:
	update_facing()
	
	var horizontal: bool = abs(last_facing.x) >= abs(last_facing.y)
	sprite.flip_h = horizontal and last_facing.x < 0
	
	var prefix: String = get_state_prefix()
	var suffix: String = get_facing_suffix()
	var animation: String = prefix + suffix
	
	#print(animation)
	#sprite.play(animation)

func update_facing() -> void:
	if velocity.length() > facing_deadzone:
		if abs(velocity.x) >= abs(velocity.y):
			last_facing = Vector2(sign(velocity.x), 0)
		else:
			last_facing = Vector2(0, sign(velocity.y))

func get_state_prefix() -> String:
	match state:
		State.IDLE:
			return "idle_"
		State.FLIGHT:
			return "flight_"
		State.REVIVE:
			return "revive_"
		State.DEAD:
			return "dead_"
		_:
			return "idle_"

func get_facing_suffix() -> String:
	if last_facing.y < 0:
		return "up"
	if last_facing.y > 0:
		return "down"
	return "right"

func scan_for_player() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
