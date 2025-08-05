extends R_SourceBuilding
class_name R_SourceEntityDoor

func _get_section() -> String:
	return "door"

func is_visible() -> bool:
	return true

func _registered() -> void:
	if not prefab:
		prefab = load("res://Games/source_game/objects/doors/base/door.tscn")
	
	get_itemstack().pickable = false
	
