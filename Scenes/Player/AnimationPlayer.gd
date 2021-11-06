extends AnimationPlayer

onready var player: Player = get_parent().get_parent()
onready var sprite: Sprite = get_parent()

var already_dead: bool = false

func _process(_delta: float) -> void:
	if player.state == player.DEAD:
		sprite.rotation_degrees = 0
		play("Death")
		return
	if G.get_input().x != 0 and player.state != player.DEAD:
		sprite.flip_h = true if G.get_input().x < 0 else false
		sprite.rotation_degrees = 7.5 * G.clamp_input(G.get_input()).x
	else:
		sprite.rotation_degrees = 0
	match player.state:
		player.IDLE:
			play("Idle")
		player.MOVE:
			play("Move")
		player.JUMP, player.FALL:
			play("Jump-Fall")
