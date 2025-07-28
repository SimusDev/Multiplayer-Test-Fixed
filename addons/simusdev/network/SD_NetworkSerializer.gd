@static_unload
extends SD_Object
class_name SD_NetworkSerializer

const TYPES: Array[int] = [
	TYPE_DICTIONARY,
	TYPE_ARRAY,
	TYPE_OBJECT,
	
]

static var _compression: FileAccess.CompressionMode = FileAccess.CompressionMode.COMPRESSION_FASTLZ
static var _min_bytes_to_compress: int = 250

static var _singleton: SD_NetworkSingleton

static func __try_compress(data: Variant, mode: int = _compression) -> PackedByteArray:
	var bytes: PackedByteArray = var_to_bytes(data)
	if bytes.size() < _min_bytes_to_compress:
		return data
	return __compress(data, mode, bytes)

static func __compress(data: Variant, mode: int = _compression, _bytes: PackedByteArray = []) -> PackedByteArray:
	var bytes: PackedByteArray = _bytes
	if bytes.is_empty():
		bytes = var_to_bytes(data)
	var compressed: PackedByteArray = bytes.compress(mode)
	return compressed

static func try_compress(data: Variant, mode: int = _compression) -> Variant:
	var str_data: String = var_to_str(data)
	var bytes: PackedByteArray = var_to_bytes(str_data)
	if bytes.size() < _min_bytes_to_compress:
		return str_data
	var compressed: PackedByteArray = bytes.compress(mode)
	return compressed

static func _parse_array(array: Array) -> Array:
	var parsed: Array = array.duplicate()
	parsed.clear()
	
	for i in array:
		parsed.append(parse(i))
	
	return parsed

static func _parse_dictionary(dict: Dictionary) -> Dictionary:
	var parsed: Dictionary = {}
	
	for key in dict:
		parsed[parse(key)] = parse(dict[key])
	
	return parsed

static func _parse_object(object: Object) -> String:
	return var_to_str(object)

static func _parse_node_reference(node: Node) -> String:
	var path: String = str(node.get_path())
	return path

static func _parse_resource(resource: Resource) -> Variant:
	var dict: Dictionary = {}
	if resource.resource_local_to_scene or resource.resource_path.is_empty():
		dict["l"] = var_to_str(resource)
	else:
		dict["p"] = resource.resource_path
	return dict

static func get_node_reference(variant: Variant) -> String:
	if variant is Dictionary:
		return variant.get("cn", "")
	return ""

static func parse(variant: Variant) -> Variant:
	#print(type_string(typeof(variant)))
	
	var type: int = typeof(variant)
	if !TYPES.has(type):
		
		return variant
	
	var packet: Dictionary = {}
	
	match type:
		TYPE_ARRAY:
			var parsed: Array = _parse_array(variant)
			packet["a"] = parsed
			return packet
			
		TYPE_DICTIONARY:
			var parsed: Dictionary = _parse_dictionary(variant)
			packet["d"] = parsed
			return packet
	
	if variant is Node:
		packet["cn"] = _parse_node_reference(variant)
		return packet
	
	if variant is Resource:
		packet["r"] = _parse_resource(variant)
		return packet
	
	if variant is Object:
		packet["o"] = _parse_object(variant)
		return packet
	
	return packet
