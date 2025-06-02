extends Area2D

var velocity = Vector2.ZERO

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	$timer.timeout.connect(_on_timeout)

func _process(delta):
	position += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("Mob"):
		body.queue_free()
		queue_free()

func _on_timeout():
	queue_free()
