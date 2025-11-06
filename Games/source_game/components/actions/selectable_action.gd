extends R_SourceWorldObject
class_name R_SelectableAction

func _get_section() -> String:
	return "action"

func is_visible() -> bool:
	return false

func _begin_show(interactor: SourceInteractRay) -> bool:
	return true

func selected(interactor: SourceInteractRay) -> void:
	pass
