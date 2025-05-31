extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const BULLET_SCENE = preload("res://scenes/bullet.tscn")  # Adjust the path to your Bullet scene

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Sprite2D = $weapon_holder/Weapon

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	 
	# Flip the direction
	if direction > 0:
		animated_sprite.flip_h = false
		weapon.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		weapon.flip_h = true
		
	# Play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Handle shooting
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet()

func shoot_bullet():
	var bullet_instance = BULLET_SCENE.instantiate()
	
	# Set the bullet's position to the weapon's position
	bullet_instance.position = weapon.global_position  # Use global_position to account for the weapon's position in the scene
	bullet_instance.direction = Vector2.RIGHT if not animated_sprite.flip_h else Vector2.LEFT  # Set direction based on facing
	
	get_parent().add_child(bullet_instance)  # Add the bullet to the scene
