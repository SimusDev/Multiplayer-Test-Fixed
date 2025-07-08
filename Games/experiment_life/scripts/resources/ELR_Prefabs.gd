extends Resource
class_name ELR_Prefabs

@export var _list: Dictionary[String, PackedScene] = {}

@export_group("Synchronization")
@export var p_sync_transform: PackedScene

func get_by_code(code: String) -> PackedScene:
	return _list.get(code, null) as PackedScene
