extends Node2D

const BULLET: PackedScene = preload("res://scenes/Gun/Bullet.tscn")

var MAG_SIZE: int = 6 # mag size
var mag: int = 6 # bullets in mag
var is_reloading: bool = false
var reload_interrupted: bool = false
var deviation: float = 5.0

func shoot() -> void:
	if is_reloading or mag <= 0:
		return
	mag -= 1
	
	#step 1: get bullet direction
	## step 1: get the bullet direction
	var cursor_pos: Vector2 = get_local_mouse_position()
	var bullet_dir: Vector2 = position.direction_to(cursor_pos)
	
	## step 2: update the direction based on the guns deviation
	var random_deviation = randf_range(-deviation, deviation)
	var angle: float = bullet_dir.angle() + deg_to_rad(random_deviation)
	bullet_dir = Vector2.from_angle(angle)
	
	## step 3: spawn the bullet with the direction
	var bullet = BULLET.instantiate()
	bullet.global_position = global_position
	bullet.direction = bullet_dir
	get_tree().current_scene.add_child(bullet)
	print("POW 💥", mag)
	
	return

func reload() -> void:
	if mag >= MAG_SIZE:
		is_reloading = false
		mag = MAG_SIZE
		return
	
	is_reloading = true
	mag += 1
	
	print(mag)
	await get_tree().create_timer(0.5).timeout
	
	if reload_interrupted:
		is_reloading = false
		reload_interrupted = false
		return
	
	reload()
	return
