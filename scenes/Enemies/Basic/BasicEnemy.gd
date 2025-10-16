extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attackArea: Area2D = $AttackArea
@onready var attackShape: CollisionShape2D = $AttackArea/CollisionShape2D

#enemy stats
var health: float = 3.0
var moveSpeed: float = 30.0
var detectionRadius: float = 100.0
var sightRadius: float = 200.0
var attackRange: float = 40.0
var attackWindup: float = 0.3
var attackActive: float = 0.10
var attackCooldown: float = 0.8
var damage: float = 1.0
var RDR: float = 0.0 #repeatedDamageReducion, part of the EATS system
var RDRGrowthRate: float = 1.3
var last_facing: Vector2 = Vector2.DOWN
var facing_deadzone: float = 0.1

#enemy states
enum State {
	IDLE,
	CHASE,
	ATTACK, 
	DEAD
}
var state: State = State.IDLE
var player: Node2D #player reference

#attack states
enum AttackPhase {
	WINDUP,
	ATTACK,
	COOLDOWN
}
var attackPhase: AttackPhase = AttackPhase.WINDUP
var attackTimer: float = 0.0
var alreadyHit: bool = false

func _ready() -> void:
	add_to_group("Enemies")
	add_to_group("EnemyBasic")
	sprite.play("idle_down")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	up_direction = Vector2.ZERO
	floor_stop_on_slope = false
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	else:
		print("no player found")
		get_tree().quit()

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
			_idle_update(delta)
		State.CHASE:
			_chase_update(delta)
		State.ATTACK:
			_attack_update(delta)
		State.DEAD: #we can't just do queue_free() on enemies because they can get ressurrected
			_dead_update(delta)
		_:
			pass
	
	update_animation()
	
	move_and_slide()

func _idle_update(_delta: float) -> void:
	velocity = Vector2.ZERO
	var distance: float = position.distance_to(player.position)
	if distance < detectionRadius:
		state = State.CHASE

func _chase_update(_delta: float) -> void:
	var direction: Vector2 = player.global_position - global_position
	if direction.length() < attackRange:
		state = State.ATTACK
		attackPhase = AttackPhase.WINDUP
		attackTimer = attackWindup
		aimAttack()
		return
	
	if direction.length() > sightRadius:
		state= State.IDLE
		return
	
	direction = direction.normalized()
	velocity = direction * moveSpeed

func _attack_update(delta: float) -> void:
	velocity = Vector2.ZERO
	attackTimer -= delta
	if attackTimer > 0.0:
		return
	
	match attackPhase:
		AttackPhase.WINDUP: #windup ended (timer ran out)
			alreadyHit = false
			attackPhase = AttackPhase.ATTACK
			attackTimer = attackActive
		AttackPhase.ATTACK: #Attack ended (timer ran out)
			#insert enemy attack function
			attack()
			attackPhase = AttackPhase.COOLDOWN
			attackTimer = attackCooldown
		AttackPhase.COOLDOWN: #cooldown ended
			print("cooldown")
			state = State.CHASE
		_:
			pass

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

func IsDead() -> bool:
	return state == State.DEAD

func revive() -> void:
	for node in get_children():
		if node is Bodypart:
			node.revive()
	state = State.IDLE
	sprite.rotation = deg_to_rad(0)
	set_collision_layer_value(2, true)
	health = 3.0

func aimAttack() -> void:
	var direction: Vector2 = player.global_position - global_position
	
	attackArea.global_position = global_position + direction
	attackArea.rotation = direction.angle()

func attack() -> void:
	if player in attackArea.get_overlapping_bodies():
		player.takeDamage(damage)

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
		State.CHASE:
			return "chase_"
		State.ATTACK:
			return "attack_"
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
