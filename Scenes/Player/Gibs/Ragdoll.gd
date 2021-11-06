extends Node2D

onready var arm_one: RigidBody2D = $Arm
onready var arm_two: RigidBody2D = $Arm2
onready var leg_one: RigidBody2D = $Leg
onready var leg_two: RigidBody2D = $Leg2
onready var shirt: RigidBody2D = $Shirt
onready var head: RigidBody2D = $Head
onready var hat: RigidBody2D = $Hat

export(float) var force: float = 20

func _ready():
	arm_one.applied_force = Vector2(-force, 0)
	arm_two.applied_force = Vector2(force, 0)
	leg_one.applied_force = Vector2(-force, 0)
	leg_two.applied_force = Vector2(force, 0)
	shirt.applied_force = Vector2(0, 0)
	hat.applied_force = Vector2(0, -force)
	
	arm_one.applied_torque = -force
	arm_two.applied_torque = force
	leg_one.applied_torque = -force
	leg_two.applied_torque = force
	shirt.applied_torque = force
	hat.applied_torque = -force
