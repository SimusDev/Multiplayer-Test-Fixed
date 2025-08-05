@static_unload
extends SD_Object
class_name SD_NetworkDeserializer

static var _compression: FileAccess.CompressionMode = FileAccess.CompressionMode.COMPRESSION_DEFLATE
static var _min_bytes_to_compress: int = 250

static var _singleton: SD_NetworkSingleton

static func __decompress(data: PackedByteArray, mode: int = _compression) -> Variant:
	var bytes: PackedByteArray = data.decompress_dynamic(-1, mode)
	var decompressed: Variant = bytes_to_var(bytes)
	return decompressed

static func __try_decompress(data: Variant, mode: int = _compression) -> Variant:
	if data is PackedByteArray:
		return __decompress(data, mode)
	return data

static func __deserialize_data(data: Variant, mode: int = _compression) -> Variant:
	if data is PackedByteArray:
		var bytes: PackedByteArray = data.decompress_dynamic(-1, mode)
		var decompressed: String = str(bytes_to_var(bytes))
		var object: Variant = str_to_var(decompressed)
		return object
	
	if data is String:
		return str_to_var(data)
	return data

static func _parse_object(object_str: String) -> Variant:
	return str_to_var(object_str)

static func _parse_array(array: Array) -> Variant:
	var result: Array = []
	for i in array:
		result.append(parse(i))
	return result

static func _parse_dictionary(dict: Variant) -> Variant:
	return dict

static func _parse_node_reference(reference: Variant) -> Variant:
	return SD_Network.singleton.cache.deserialize_node_reference(reference)

static var _CALLABLES = {
	"cn": _parse_node_reference,
	"o": _parse_object,
	"r": _parse_resource,
}

static func _parse_resource(resource: Variant) -> Variant:
	return SD_Network.singleton.cache.deserialize_resource(resource)

static var _CALLABLE_TYPES = {
	TYPE_ARRAY: _parse_array,
	TYPE_DICTIONARY: _parse_dictionary,
}

static var _PARSER_CALLABLES: Dictionary[int, Callable] = {
	SD_NetworkSerializer.PACKET_TYPE.ARRAY: _parse_array,
	SD_NetworkSerializer.PACKET_TYPE.DICTIONARY: _parse_dictionary,
	SD_NetworkSerializer.PACKET_TYPE.NODE: _parse_node_reference,
	SD_NetworkSerializer.PACKET_TYPE.RESOURCE: _parse_resource,
	SD_NetworkSerializer.PACKET_TYPE.OBJECT: _parse_object,
}

static func parse(serialized: Variant) -> Variant:
	if serialized is Array:
		if serialized.size() == 2:
			var type_id: int = SD_Array.get_value_from_array(serialized, 1, -1) as int
			if _PARSER_CALLABLES.has(type_id):
				var value: Variant = serialized[0]
				var callable: Callable = _PARSER_CALLABLES[type_id]
				var result: Variant = callable.call(value)
				return result
	return serialized
	
