extends R_SourceWorldObject
class_name R_SourceAmmoObject

@export var damage: float = 10
@export var explode: bool = false

func get_node_script() -> GDScript:
	return SourceProp

func _get_section() -> String:
	return "weapon.ammo"
