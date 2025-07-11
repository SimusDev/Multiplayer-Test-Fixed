extends SB_WorldObject
class_name SB_WorldEntity

@export_group("World")
@export var ragdoll: SB_WorldRagdoll

func get_level_section() -> String:
	return "entities"
