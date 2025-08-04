extends Resource
class_name SourceItemAction

@export var code: String = "" : get = get_code

func _init() -> void:
	pass

func get_code() -> String:
	if code:
		return code
	return "action"

func _action(item: SourceItemStack) -> void:
	pass

func _action_server(item: SourceItemStack) -> void:
	pass

func _action_local(item: SourceItemStack) -> void:
	item.drop()
