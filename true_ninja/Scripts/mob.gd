extends CharacterBody2D

@export var speed = 200

@onready var player = get_node("/root/main/player")
@onready var anim = $AnimatedSprite2D
@onready var damage_area = $DamageArea
@onready var damage_timer = $DamageTimer


var player_in_range = null

func _ready():
	add_to_group("enemies")
	if damage_area:
		damage_area.body_entered.connect(_on_damage_area_body_entered)
		damage_area.body_exited.connect(_on_damage_area_body_exited)

	if damage_timer:
		damage_timer.timeout.connect(_on_damage_timer_timeout)

func _physics_process(delta):
	if player == null or player.is_dead:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	_update_animation()

func _update_animation():
	if velocity.length() > 0.0:
		if abs(velocity.x) > abs(velocity.y):
			anim.play("right" if velocity.x > 0 else "left")
			anim.flip_h = false
		else:
			anim.play("down" if velocity.y > 0 else "up")
	else:
		anim.play("down")

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player") and body.has_method("take_damage"):
		player_in_range = body
		damage_timer.start()

func _on_damage_area_body_exited(body):
	if body == player_in_range:
		player_in_range = null
		damage_timer.stop()

func _on_damage_timer_timeout():
	if player_in_range and not player_in_range.is_dead:
		player_in_range.take_damage(5)
