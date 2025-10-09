extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

#enemy stats
var health: float = 3.0
var moveSpeed: float = 120.0
var detectionRadius: float = 500.0
var sightRadius: float = 1000.0

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
	
	#TODO: detect dead teammates to revive

func _flight_update(_delta: float) -> void:
	var direction: Vector2 = player.global_position - global_position
	
	if direction.length() > sightRadius:
		state= State.IDLE
		return
	
	direction = direction.normalized()
	velocity = -direction * moveSpeed

func _revive_update(delta: float) -> void:
	pass

func _dead_update(delta: float) -> void:
	velocity = Vector2.ZERO
	sprite.rotation = deg_to_rad(180-60)

func TakeDamage(dmg: float) -> void:
	health -= dmg
	if health <= 0:
		state = State.DEAD
		set_collision_layer_value(2, false)

func DetectDead() -> void:
	var deadEnemies: Array[Node]
	
	for enemy in enemies:
		if enemy.IsDead():
			deadEnemies.append(enemy)
