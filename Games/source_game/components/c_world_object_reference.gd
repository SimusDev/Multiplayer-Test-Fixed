extends RefCounted
class_name C_SourceWorldObjectReference

var source: Node
var object: R_SourceWorldObject

func instantiate() -> C_SourceWorldObjectReference:
	SourceGame.instance.instantiate_object_on_server(source)
	return self

func set_global_position(position: Variant) -> C_SourceWorldObjectReference:
	if "global_position" in source:
		source.global_position = position
	return self

func get_global_position_at(at: Variant) -> C_SourceWorldObjectReference:
	var vector: Vector3 = SourceObject.get_vector3_position(at)
	set_global_position(vector)
	return self

func set_global_position_from(node: Node) -> C_SourceWorldObjectReference:
	if "global_position" in node:
		set_global_position(node.global_position)
	return self

func set_global_transform(transform: Variant) -> C_SourceWorldObjectReference:
	if "global_transform" in source:
		source.global_transform = transform
	return self

func set_global_transform_from(node: Node) -> C_SourceWorldObjectReference:
	if "global_transform" in node:
		set_global_transform(node.global_transform)
	return self


func instantiate_local() -> C_SourceWorldObjectReference:
	SourceGame.instance.instantiate_object_local(source)
	return self
