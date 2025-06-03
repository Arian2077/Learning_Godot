extends Node2D

@export var mob_scene: PackedScene
@onready var spawn_timer = $SpawnTimer
@onready var spawn_check_ray = get_node("../SpawnCheckRay")

const MIN_X = -5500
const MAX_X = 2000
const MIN_Y = -10750
const MAX_Y = -3000

const MIN_DISTANCE = 200
const MAX_DISTANCE = 500

@onready var player = get_node("/root/main/player")

func _ready():
	randomize()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	spawn_check_ray.enabled = true
	spawn_check_ray.collision_mask = 3

func _on_spawn_timer_timeout():
	if not mob_scene or player == null:
		return

	var tries = 10
	while tries > 0:
		var angle = randf_range(0, TAU)
		var distance = randf_range(MIN_DISTANCE, MAX_DISTANCE)
		var offset = Vector2.RIGHT.rotated(angle) * distance
		var spawn_pos = player.global_position + offset

		if spawn_pos.x >= MIN_X and spawn_pos.x <= MAX_X and spawn_pos.y >= MIN_Y and spawn_pos.y <= MAX_Y:
			if not _is_position_blocked(spawn_pos):
				spawn_mob(spawn_pos)
				return

		tries -= 1

func _is_position_blocked(position: Vector2) -> bool:
	if not spawn_check_ray:
		return true
	spawn_check_ray.global_position = position
	spawn_check_ray.target_position = Vector2(0, 64)
	spawn_check_ray.force_raycast_update()
	if spawn_check_ray.is_colliding():
		var collider = spawn_check_ray.get_collider()
		if collider and collider.is_in_group("Obstacles"):
			return true
	return false

func spawn_mob(position: Vector2):
	var mob = mob_scene.instantiate()
	mob.position = position
	get_parent().get_parent().add_child(mob)
