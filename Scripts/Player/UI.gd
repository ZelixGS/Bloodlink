extends CanvasLayer

onready var debug_text: Label = $Control/Label

onready var player: Player = get_tree().get_nodes_in_group("Player").front()
onready var health_bar: TextureProgress = $Control/Healthbar

func _process(_delta: float):
	health_bar.value = G.player.current_health
	debug_text.text = str("FPS: %s" % [Engine.get_frames_per_second()])
	debug_text.text += str("\nInput: %s" % [G.get_input()])
	debug_text.text += str("\nPosition: %.1f/%.1f" % [player.position.x, player.position.y])
	debug_text.text += str("\nVelocity: %.1f, %.1f" % [player.velocity.x,player.velocity.y])
	debug_text.text += str("\nCeiling: %s" % [player.detect_ceiling()])
	debug_text.text += str("\nWall: %s" % [player.is_on_wall()])
	debug_text.text += str("\nFloor: %s" % [player.is_on_floor()])
	debug_text.text += str("\nState: %s" % [state_to_string(player.state)])
	debug_text.text += str("\nLast State: %s" % [state_to_string(player.previous_state)])
	debug_text.text += str("\nJump Buffer Time: %s" % [player.jump_buffer_timer.time_left])
	debug_text.text += str("\nCoyate Buffer Time: %s" % [player.jump_coyate_timer.time_left])
	pass

func state_to_string(value: int) -> String:
	var temp: String = "N/A"
	match value:
		player.DEAD:
			temp = "Dead"
		player.IDLE:
			temp = "Idle"
		player.MOVE:
			temp = "Moving"
		player.JUMP:
			temp = "Jumping"
		player.FALL:
			temp = "Falling"
		player.CROUCH:
			temp = "Crouching"
		player.CRAWL:
			temp = "Crawling"
		player.SLIDE:
			temp = "Sliding"
		player.LEDGE:
			temp = "Ledge"
		player.LEDGECLIMB:
			temp = "Climbing"
		player.POWERSLIDE:
			temp = "Powersliding"
		player.GROUNDSLAM:
			temp = "POWER SLAM!!"
	return(temp)
