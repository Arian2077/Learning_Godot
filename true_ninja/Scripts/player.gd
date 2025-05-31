extends CharacterBody2D


@onready var hero: AnimatedSprite2D = $AnimatedSprite2D

var last_direction = "Down"

func _physics_process(delta: float):
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
		hero.play("stand_"+last_direction)
