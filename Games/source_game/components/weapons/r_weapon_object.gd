extends R_SourceItem
class_name R_WeaponObject

func get_node_script() -> GDScript:
	return SourceProp

func _get_section() -> String:
	return "weapon"

func _registered() -> void:
	get_itemstack().stackable = false
