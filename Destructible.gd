extends StaticBody2D

export(float) var respawn: float = 5.0

onready var collision: CollisionShape2D = $CollisionShape2D
onready var area2d: CollisionShape2D = $Area2D/CollisionShape2D
onready var sprite: Sprite = $Sprite
onready var timer: Timer = $Timer

func rebuild() -> void:
	collision.disabled = false
	area2d.disabled = false
	sprite.visible = true


func destroy() -> void:
	collision.disabled = true
	area2d.disabled = true
	sprite.visible = false
	timer.start(respawn)

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area is Projectile:
		if area.creator == "Player":
			call_deferred("destroy")

func _on_Timer_timeout() -> void:
	rebuild()
