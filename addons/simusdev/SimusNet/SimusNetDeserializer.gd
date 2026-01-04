@static_unload
extends RefCounted
class_name SimusNetDeserializer

static var _settings: SimusNetSettings

func _init() -> void:
	_settings = SimusNetSettings.get_or_create()

static var __type_and_method: Dictionary[SimusNetSerializer.TYPE, Callable] = {
	SimusNetSerializer.TYPE.RESOURCE: _parse_resource,
	SimusNetSerializer.TYPE.OBJECT: _parse_object,
	SimusNetSerializer.TYPE.NODE: _parse_node,
	SimusNetSerializer.TYPE.ARRAY: _parse_array,
}

static func _parse_resource(data: Variant) -> Resource:
	if data is String:
		return load(data)
	return load(SimusNetResources.get_cached().get(data))

static func _parse_object(data: Variant) -> Object:
	return null

static func _parse_node(data: Variant) -> Node:
	return null

static func _parse_array(data: Array) -> Array:
	var parsed: Array = []
	for i in data:
		parsed.append(parse(data))
	
	return parsed

static func parse(variant: Variant, try: bool = true) -> Variant:
	if !try:
		return variant
	
	if variant is Array:
		if variant.size() == SimusNetSerializer.ARRAY_SIZE:
			var first: Variant = variant.get(0)
			var second: Variant = variant.get(1)
			
			if typeof(first) == TYPE_INT:
				return __type_and_method[first].call(second)
			
			
	return variant

static func _throw_error(...args: Array) -> void:
	if _settings.debug_enable:
		printerr("[SimusNetDeserializer]: ")
		printerr(args)
