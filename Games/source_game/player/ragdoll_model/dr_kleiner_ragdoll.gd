extends Node3D

@onready var skeleton = $model/Skeleton3D
@onready var physical_bones_simulator = skeleton.get_node("PhysicalBoneSimulator3D")

func _ready() -> void:
	physical_bones_simulator.physical_bones_start_simulation()
