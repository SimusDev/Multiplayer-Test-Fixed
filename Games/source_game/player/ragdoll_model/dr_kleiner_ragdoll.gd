extends Node3D

@onready var skeleton = $Skeleton3D
@onready var physical_bones_simulator = $Skeleton3D/PhysicalBoneSimulator3D

func _ready() -> void:
	physical_bones_simulator.physical_bones_start_simulation()
