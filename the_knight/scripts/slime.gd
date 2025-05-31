extends Node2D

const SPEED = 60
var direction = -1
@onready var ray_cast_right: RayCast2D = $ray_cast_right
@onready var ray_cast_left: RayCast2D = $ray_cast_left
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var health = 20

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()  # Remove the slime from the scene

# This function will be called when the slime collides with a bullet
func _on_Bullet_body_entered(body):
	if body.is_in_group("bullets"):  # Assuming bullets are added to a group called "bullets"
		take_damage(1)  # Adjust the damage amount as needed
