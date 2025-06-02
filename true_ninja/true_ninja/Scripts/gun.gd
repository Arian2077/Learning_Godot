extends Node2D

var sword_scene = preload("res://Scenes/sword.tscn")

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var angle = (mouse_pos - global_position).angle()
	$weapon_pivot/pistol.visible = false

func _input(event):
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	$weapon_pivot/pistol.visible = true
	var sword = sword_scene.instantiate()
	
	get_tree().current_scene.add_child(sword)
	sword.global_position = $weapon_pivot/shootingPivot.global_position
	
	var dir = (get_global_mouse_position() - sword.global_position).normalized()
	sword.velocity = dir * 600
	
	await get_tree().create_timer(0.2).timeout
	$weapon_pivot/pistol.visible = false
