extends Resource
class_name SourceInitialItemStack

@export var object: R_SourceWorldObject : get = get_object
@export var quantity: int = 1

func get_object() -> R_SourceWorldObject:
	if object:
		return object
	return R_SourceWorldObject.get_placeholder()
