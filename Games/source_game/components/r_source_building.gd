class_name R_SourceBuilding extends R_SourceWorldObject

func _get_section() -> String:
	return "buildings"

func is_visible() -> bool:
	return false

func _registered() -> void:
	get_itemstack().pickable = false
