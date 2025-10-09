extends CharacterBody2D

@onready var sprite = $Sprite2D

#enemy stats
var health: float = 3.0
var moveSpeed: float = 120.0
var detectionRadius: float = 500.0
var sightRadius: float = 1000.0
var attackRange: float = 200.0
var attackWindup: float = 0.3
var attackActive: float = 0.10
var attackCooldown: float = 0.8
var damage: int = 1
var DDR: float = 0.0 #repeatedDamageReducion, part of the EATS system
var DDRGrowthRate: float = 1.3

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


func _ready() -> void:
	add_to_group("Enemies")
	add_to_group("EnemyBasic")
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
			print("windup")
			attackPhase = AttackPhase.ATTACK
			attackTimer = attackActive
		AttackPhase.ATTACK: #Attack ended (timer ran out)
			#insert enemy attack function
			print("attack")
			attackPhase = AttackPhase.COOLDOWN
			attackTimer = attackCooldown
		AttackPhase.COOLDOWN: #cooldown ended
			print("cooldown")
			state = State.CHASE
		_:
			pass

func _dead_update(_delta: float) -> void:
	pass


func TakeDamage(dmg: int) -> void:
	health -= dmg - (dmg * DDR)
	if DDR == 0.0:
		DDR = 0.1
	else:
		DDR *= DDRGrowthRate
		if DDR > 0.8:
			DDR = 0.8
	
	if (health <= 0.0):
		state = State.DEAD
		velocity = Vector2.ZERO
		set_collision_layer_value(2, false)
		sprite.rotation = deg_to_rad(180)

func IsDead() -> bool:
	return state == State.DEAD

func revive() -> void:
	state = State.IDLE
	sprite.rotation = deg_to_rad(0)
	set_collision_layer_value(2, true)
	health = 3.0
