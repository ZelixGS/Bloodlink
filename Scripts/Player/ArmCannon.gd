extends Sprite

onready var player: Player = get_parent()
onready var ray: RayCast2D = $RayCast2D
onready var line: Line2D = $Line2D
onready var barrel: Position2D = $Position2D
onready var projectile: PackedScene = preload("res://Scenes/Objects/Projectile.tscn")

func _physics_process(_delta: float) -> void:
	var a = G.get_input().angle()
	rotation = stepify(a, PI/4)
	ray.force_raycast_update()
	if ray.is_colliding():
		line.points[1] = to_local(ray.get_collision_point())
	else:
		line.points[1] = ray.cast_to
#	if Input.is_action_pressed("aim"):
#		ray.enabled = true
#		rotation = G.get_input().angle()
#	else:
#		rotation = 0

func _input(_event):
	if Input.is_action_just_pressed("fire"):
		var new_projectile = projectile.instance()
		new_projectile.creator = "Player"
		new_projectile.transform = barrel.global_transform
		get_node("/root").add_child(new_projectile)
#	if G.get_input().y < 0.3 and G.get_input().y > -0.3:
#		rotation_degrees = 0
#	if G.get_input().y > 0.3:
#		rotation_degrees = 45
#	if G.get_input().y < -0.3:
#		rotation_degrees = -45
#	if G.get_input().y < -0.8:
#		rotation_degrees = -90
