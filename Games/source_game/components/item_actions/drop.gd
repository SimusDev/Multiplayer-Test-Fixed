extends SourceItemAction
class_name SourceItemActionDrop

func get_code() -> String:
	return "drop"

func _action_local(item: SourceItemStack) -> void:
	item.drop()
