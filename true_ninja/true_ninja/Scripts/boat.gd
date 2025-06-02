extends AnimatableBody2D

@onready var boat: Sprite2D = $Sprite2D

# Define thresholds
var left_limit = 2347
var right_limit = -6631

func _process(delta):
	if boat.position.x > right_limit:
		boat.flip_h = false
	elif boat.position.x < left_limit:
		boat.flip_h = true
