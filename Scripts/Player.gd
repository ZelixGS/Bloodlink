class_name Player
extends KinematicBody2D

# Related to state machine logic, went with enum instead of strings to have less typing.
# We do maintain a previous state knowledge in case we need it in the future, but was largely
# debugging.
onready var ragdoll: PackedScene = preload("res://Scenes/Player/Gibs/Ragdoll.tscn")

enum {DEAD, IDLE, MOVE, JUMP, FALL}
var state: int = FALL setget set_state
var previous_state: int = 1

export(bool) var allow_input: bool = true
export(bool) var can_move: bool = true
export(bool) var use_gravity: bool = true

export(float) var move_speed: float = 160.0
export(float) var jump_buffer: float = 0.2
export(float) var coyate_buffer: float = 0.2
var max_velocity: float = move_speed
var current_max_velocity: float = max_velocity

var was_on_floor: bool = false
var hit_the_ground: bool = false
var last_facing: int = 1
var velocity: Vector2 = Vector2.ZERO
var floor_snap: Vector2

onready var facing: Node2D = $Facing
onready var sprite: Sprite = $Sprite
onready var ray_ceiling: RayCast2D = $Facing/Rays/Ceiling
onready var ray_forward: RayCast2D = $Facing/Rays/Forward
onready var camera: Camera2D = $GameCamera
onready var jump_buffer_timer: Timer = $Timers/JumpBuffer
onready var jump_coyate_timer: Timer = $Timers/JumpCoyate

# Kinematic Variables related to jump height, pre-post peak gravity, and sliding.
# Sliding still needs some work.
export(float) var jump_height: float = 32.0
export(float) var jump_time_to_peak: float = 0.4
export(float) var jump_time_to_fall: float = 0.3
onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0

export(int) var max_health: int = 100
var current_health: int = max_health setget update_health

func update_health(value: int) -> void:
	current_health += value
	current_health = clamp(current_health, 0, max_health)
	if current_health <= 0:
		death()

func _physics_process(delta: float) -> void:
	handle_state(delta)

func set_state(new_state: int) -> void:
	previous_state = state
	state = new_state

func handle_state(delta: float) -> void:
	if state == DEAD:
		return
	elif [IDLE, MOVE].has(state):
		apply_gravity(delta)
		if not is_on_floor():
			set_state(FALL)
		else:
			set_state(MOVE if abs(G.get_input().x) > 0 else IDLE)
		if Input.is_action_just_pressed("jump") or not jump_buffer_timer.is_stopped():
			jump()
		apply_velocity()
	elif state == JUMP:
		apply_gravity(delta) 
		if velocity.y > 0 and !is_on_floor():
			set_state(FALL)
		if Input.is_action_just_pressed("jump"):
			jump()
		apply_velocity()
	elif state == FALL:
		apply_gravity(delta)
		if Input.is_action_just_pressed("jump"):
			jump()
		if is_on_floor():
			set_state(IDLE)
		apply_velocity()

func apply_velocity() -> void:
	if was_on_floor and not is_on_floor() and state != JUMP:
		jump_coyate_timer.start(coyate_buffer)
	if G.get_input().x != 0:
		last_facing = facing.scale.x
		facing.scale.x = G.clamp_input(G.get_input()).x
	velocity.x = get_speed()
	floor_snap = Vector2.DOWN * 8 if state != JUMP else Vector2.ZERO
	was_on_floor = is_on_floor()
	velocity = move_and_slide_with_snap(velocity, floor_snap, Vector2.UP, true)

func get_speed() -> float:
	var speed: float = 0.0
	if abs(G.get_input().x) > 0:
		speed = move_speed * (-1 if G.get_input().x < 0 else 1)
	return speed if can_move else 0.0

func jump() -> void:
	if not is_on_floor() and jump_coyate_timer.is_stopped():
		jump_buffer_timer.start(jump_buffer)
	else:
		set_state(JUMP)
		velocity.y = jump_velocity

func apply_gravity(delta: float) -> void:
	var gravity: float = jump_gravity if velocity.y < 0.0 else fall_gravity
	velocity.y += gravity * delta if not is_on_floor() else 0.0

func detect_ceiling() -> bool:
	return true if ray_ceiling.is_colliding() else false

func death() -> void:
	set_state(DEAD)
	$Standing.disabled = true
	$Sprite.visible = false
	var new_ragdoll = ragdoll.instance()
	new_ragdoll.transform = global_transform
	get_node("/root").add_child(new_ragdoll)

func _unhandled_input(event) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("restart"):
		var _discard := get_tree().reload_current_scene()
	if event.is_action_pressed("suicide"):
		death()
