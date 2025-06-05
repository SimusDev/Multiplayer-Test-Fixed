extends Node3D

@export var vehicle:Vehicle
@onready var steering_wheel = $Object_3/steering_wheel

func _physics_process(_delta: float) -> void:
	steering_wheel.rotation_degrees.z = vehicle.true_steering_amount * 900
