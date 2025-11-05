extends R_WeaponObject
class_name R_WeaponProjectileObject

@export var max_ammo: int = 30

func get_node_script() -> GDScript:
	return SourceProp

func _get_section() -> String:
	return "weapon"
