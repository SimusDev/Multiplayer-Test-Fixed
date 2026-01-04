@static_unload
extends RefCounted
class_name SimusNetSerializer

static var _settings: SimusNetSettings

const ARRAY_SIZE: int = 2

enum TYPE {
	OBJECT,
	RESOURCE,
	IDENTITY,
	NODE,
	ARRAY,
}

func _init() -> void:
	_settings = SimusNetSettings.get_or_create()

static var __class_and_method: Dictionary[StringName, Callable] = {
	"Resource": _parse_resource,
	"Object": _parse_object,
	"Node": _parse_node,
	"Array": _parse_array,
}

static func _parse_resource(variant: Resource, data: Array = []) -> void:
	data.append(TYPE.RESOURCE)
	var id: int = SimusNetResources.get_unique_id(variant)
	if id > -1:
		data.append(id)
	else:
		SimusNetResources.cache(variant)
		data.append(SimusNetResources.get_unique_path(variant))

static func _parse_object(variant: Object, data: Array = []) -> void:
	pass

static func _parse_node(variant: Node, data: Array = []) -> void:
	data.append(TYPE.NODE)

static func _parse_array(variant: Array, data: Array = [], try: bool = true) -> Array:
	if !try:
		return variant
	
	data.append(TYPE.ARRAY)
	var parsed: Array = []
	for i in variant:
		parsed.append(parse(i))
	data.append(parsed)
	return parsed

static func parse(variant: Variant, try: bool = true) -> Variant:
	if !try:
		return variant
	
	var parsed: Array = []
	var type_string: String = type_string(typeof(variant))
	if variant is Object:
		type_string = variant.get_class()
	
	var parsable: bool = false
	for c in __class_and_method:
		if c == type_string:
			parsable = true
			__class_and_method[c].call(variant, parsed)
			break
	
	if !parsable:
		return variant
	
	if parsed.is_empty():
		_throw_error("failed to serialize: (%s), %s" % [type_string, variant])
		return null
	return parsed

static func _throw_error(...args: Array) -> void:
	if _settings.debug_enable:
		printerr("[SimusNetSerializer]: ")
		printerr(args)
