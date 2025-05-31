extends CharacterBody2D

@onready var hero: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float):
	var direction = Input.get_vector('move_left','move_right','move_up','move_down')
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0:
		hero.play("run")
		if velocity.x > 0:
			hero.flip_h = true
		elif velocity.x < 0:
			hero.flip_h = false
	else:
		hero.play("stand")
