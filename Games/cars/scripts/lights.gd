extends Node3D
class_name CarLight

@export var vehicle:Vehicle

@export var front_lights:Array[Light3D]
@export var rear_lights:Array[Light3D]

func _process(delta: float) -> void:
	for light in rear_lights:
		light.light_energy = int(vehicle.brake_amount)
