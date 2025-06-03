extends Node2D

@onready var spawn_timer: Timer = $EnemySpawner/SpawnTimer
var player_connected := false



func _process(_delta):
	if not player_connected:
		var player = get_node_or_null("player")
		if player and player.has_signal("player_died"):
			player.player_died.connect(_on_player_died)
			player_connected = true

func _on_player_died():
	spawn_timer.stop()
	
