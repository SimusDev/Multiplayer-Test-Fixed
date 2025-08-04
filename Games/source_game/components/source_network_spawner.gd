extends SD_NetworkSpawner
class_name SourceNetworkSpawner

func can_serialize(node: Node) -> bool:
	return super(node)

func _serialize_custom(node: Node, data: Dictionary) -> void:
	var object: R_SourceWorldObject = R_SourceWorldObject.find_in(node)
	if object:
		data.so = object.id

func _deserialize_custom(node: Node, data: Dictionary) -> void:
	var object: R_SourceWorldObject = R_SourceWorldObject.get_by_id(data.get("so", ""))
	if object:
		object.set_in(node)
	
