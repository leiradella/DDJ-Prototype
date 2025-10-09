extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

#enemy stats
var health: float = 3.0
var moveSpeed: float = 120.0
var detectionRadius: float = 350.0
var sightRadius: float = 1000.0
var reviveRange: float = 200.0
var reviveTime: float = 2.0
var DDR: float = 0.0 #repeatedDamageReducion, part of the EATS system
var DDRGrowthRate: float = 1.1

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
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	up_direction = Vector2.ZERO
	floor_stop_on_slope = false
	
	enemies = get_tree().get_nodes_in_group("EnemyBasic")
	
	var players: Array[Node] = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	else:
		print("no player found")
		get_tree().quit()
	


func _physics_process(delta: float) -> void:
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

func _revive_update(_delta: float) -> void:
	var targetDirection: Vector2 = target.global_position - global_position
	var playerDistance: float = global_position.distance_to(player.global_position)
	
	if playerDistance < detectionRadius:
		state = State.FLIGHT
		return
	
	if targetDirection.length() < reviveRange:
		velocity = Vector2.ZERO
		await get_tree().create_timer(reviveTime).timeout
		target.revive()
		state = State.IDLE
		return
	
	targetDirection = targetDirection.normalized()
	velocity = targetDirection * moveSpeed

func _dead_update(_delta: float) -> void:
	pass

func TakeDamage(dmg: float) -> void:
	health -= dmg - (dmg * DDR)
	if DDR == 0.0:
		DDR = 0.1
	else:
		DDR *= DDRGrowthRate
	
	if health <= 0:
		state = State.DEAD
		set_collision_layer_value(2, false)
		velocity = Vector2.ZERO
		set_collision_layer_value(2, false)
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
		state = State.REVIVE
