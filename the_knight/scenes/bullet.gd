extends Area2D

signal hit



var speed = 300
var direction = Vector2.ZERO
var velocity = Vector2.ZERO



func _ready():
	velocity = direction.normalized() * speed
	
func _physics_process(delta):
	# Move the bullet based on its velocity
	position += velocity * delta

func _on_Area2D_body_entered(body):
	if body.is_in_group("slimes"):  # Assuming slimes are added to a group called "slimes"
		body._on_Bullet_body_entered(self)
		queue_free()  # Remove the bullet after hitting
	
	# Free the bullet after hitting something
	queue_free()


func _on_hit() -> void:
	pass # Replace with function body.
