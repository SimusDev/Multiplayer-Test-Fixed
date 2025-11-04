extends R_WeaponObject
class_name R_WeaponMeleeObject

func get_node_script() -> GDScript:
	return SourceProp

func _get_section() -> String:
	return "weapon"
