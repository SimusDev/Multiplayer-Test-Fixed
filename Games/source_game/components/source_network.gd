extends Node
class_name SourceNetwork

static func serialize_resource(resource: Resource) -> Variant:
	if resource.resource_path.is_empty():
		return {1: var_to_str(resource)}
	return resource.resource_path.replacen(SourceGame.GAME_PATH, "")

static func deserialize_resource(resource: Variant) -> Resource:
	if resource is Dictionary:
		return str_to_var(resource.get(1, ""))
	return load(SourceGame.GAME_PATH.path_join(resource))
