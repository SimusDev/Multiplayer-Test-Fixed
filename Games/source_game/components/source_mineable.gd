@icon("res://Games/source_game/components/icons/mineable.png")
class_name SourceMineable extends Node

signal destroyed

@export var root:Node3D
@export var resource:R_SourceMineable
@export var spawn_radius: float = 2.0

func _exit_tree() -> void:
	if SD_Network.is_server():
		for world_obj in resource.drop:
			var reference: C_SourceWorldObjectReference = world_obj.create().instantiate()
			var rand_pos:Vector3 = Vector3(
				randf_range(-spawn_radius, spawn_radius),
				1,
				randf_range(-spawn_radius, spawn_radius)
			)
			reference.set_global_position(rand_pos)
			
		destroyed.emit()
