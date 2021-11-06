class_name Projectile
extends Area2D

export(String, "Enemy", "Player") var creator: String = "Enemy"

export(float) var speed: float = 750.0

func _ready():
	set_as_toplevel(true)

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_Projectile_body_entered(body) -> void:
	if body is TileMap:
		$AnimatedSprite.visible = false
		queue_free()
