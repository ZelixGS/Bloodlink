extends Position2D

onready var player: Player = get_parent().get_parent()
onready var projectile: PackedScene = preload("res://Scenes/Objects/Projectile.tscn")

func _input(_event):
	if Input.is_action_just_pressed("fire") and player.state != player.DEAD:
		player.current_health = -5
		var new_projectile = projectile.instance()
		new_projectile.creator = "Player"
		new_projectile.transform = global_transform
		get_node("/root").add_child(new_projectile)
