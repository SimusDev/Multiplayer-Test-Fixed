extends R_SourceWorldObject
class_name R_SourceEntity

@export var ragdoll: R_SourceRagdoll

func is_destroyable() -> bool:
	return true

func _get_section() -> String:
	return "entity"

func _registered() -> void:
	get_itemstack().pickable = false
