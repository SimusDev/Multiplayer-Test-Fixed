extends Resource
class_name EL_WorldObject

@export_group("World")
@export var prefab_world: PackedScene



func get_level_section() -> String:
	return "Objects"
