extends CharacterBody2D

@onready var hero: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = $HealthBar/ProgressBar
@onready var game_over_ui = $GameOverUI

@export var max_health: int = 100
var current_health: int
var last_direction = "Down"
var is_dead = false
signal player_died

func _ready():
	current_health = max_health
	update_health_bar()
	hero.animation_finished.connect(_on_animation_finished)
	game_over_ui.visible = false

func _physics_process(delta: float):
	if is_dead:
		return
	
	var input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector * 600
	move_and_slide()

	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				hero.play("Right")
				last_direction = "Right"
			else:
				hero.play("Left")
				last_direction = "Left"
		else:
			if input_vector.y > 0:
				hero.play("Down")
				last_direction = "Down"
			else:
				hero.play("Up")
				last_direction = "Up"
	else:
		hero.play("stand_" + last_direction)

func take_damage(amount: int):
	if is_dead:
		return
	
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	update_health_bar()
	
	if current_health <= 0:
		die()

func update_health_bar():
	health_bar.value = current_health
	
	var color: Color
	if current_health > 66:
		color = Color.GREEN
	elif current_health > 33:
		color = Color.YELLOW
	else:
		color = Color.RED
	
	var stylebox = health_bar.get("theme_override_styles/fill")
	if stylebox:
		stylebox.bg_color = color

func die():
	if is_dead:
		return
	
	is_dead = true
	emit_signal("player_died")
	hero.play("death")
	set_physics_process(false)
	set_process(false)
	game_over_ui.visible = true

func _on_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()

func _on_restart_button_pressed():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	get_tree().reload_current_scene()
