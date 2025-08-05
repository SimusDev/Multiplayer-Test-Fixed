@static_unload
extends SD_Object
class_name SD_NetworkSerializer

const TYPES: Array[int] = [
	TYPE_DICTIONARY,
	TYPE_ARRAY,
	TYPE_OBJECT,
	
]

enum PACKET_TYPE {
	ARRAY,
	DICTIONARY,
	OBJECT,
	NODE,
	RESOURCE,
	
}

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

static func _parse_array(array: Array) -> Variant:
	var result: Array = []
	for i in array:
		result.append(parse(i))
	return result

static func _parse_dictionary(dict: Variant) -> Variant:
	return dict

static func _parse_object(object: Object) -> String:
	return var_to_str(object)

static func _parse_node_reference(node: Node) -> Variant:
	return SD_Network.singleton.cache.serialize_node_reference(node)

static func _parse_resource(resource: Resource) -> Variant:
	return SD_Network.singleton.cache.serialize_resource(resource)

static var _PARSER_CALLABLES: Dictionary[String, Array] = {
	"Array": [_parse_array, PACKET_TYPE.ARRAY],
	"Dictionary": [_parse_dictionary, PACKET_TYPE.DICTIONARY],
	"Node": [_parse_node_reference, PACKET_TYPE.NODE],
	"Resource": [_parse_resource, PACKET_TYPE.RESOURCE],
	"Object": [_parse_object, PACKET_TYPE.OBJECT],
}

static func parse(variant: Variant) -> Variant:
	#print(type_string(typeof(variant)))
	
	var packet: Array = []
	var type_string: String = type_string(typeof(variant))
	
	if variant is Object:
		type_string = "Object"
	
	if variant is Resource:
		type_string = "Resource"
	
	if variant is Node:
		type_string = "Node"
	
	
	if _PARSER_CALLABLES.has(type_string):
		var arguments: Array = _PARSER_CALLABLES[type_string]
		var callable: Callable = arguments[0]
		var packet_type: int = arguments[1]
		var result: Variant = callable.call(variant)
		packet.append(result)
		packet.append(packet_type)
		return packet
	return variant
	
