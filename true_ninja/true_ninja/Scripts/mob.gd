extends CharacterBody2D

@export var speed = 250
@onready var player = get_node("/root/main/player")
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

  
	if velocity.length() > 0.0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				anim.play("right")
				anim.flip_h = false
			else:
				anim.play("left")
				anim.flip_h = false
		else:
			if velocity.y > 0:
				anim.play("down")
			else:
				anim.play("up")
	else:
		anim.play("down")
