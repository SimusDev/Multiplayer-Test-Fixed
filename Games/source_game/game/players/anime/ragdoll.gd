extends Node3D

@export var simulator: PhysicalBoneSimulator3D

func _ready() -> void:
	simulator.physical_bones_start_simulation()
