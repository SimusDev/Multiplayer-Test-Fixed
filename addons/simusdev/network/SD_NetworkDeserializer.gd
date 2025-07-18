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
	return str_to_var(data)

static func _parse_object(object_str: String) -> Variant:
	return str_to_var(object_str)

static func _parse_array(array: Array) -> Array:
	var parsed: Array = array.duplicate()
	parsed.clear()
	
	for i in array:
		parsed.append(parse(i))
	
	return parsed

static func _parse_dictionary(dict: Dictionary) -> Dictionary:
	var parsed: Dictionary = dict.duplicate()
	parsed.clear()
	
	for key in dict:
		parsed[parse(key)] = parse(dict[key])
	
	return parsed

static func _parse_node_reference(path: String) -> Variant:
	return SimusDev.get_node_or_null(path)

static var _CALLABLES = {
	"a": _parse_array,
	"d": _parse_dictionary,
	"cn": _parse_node_reference,
	"o": _parse_object,
	"r": _parse_resource,
}

static func parse(serialized: Variant) -> Variant:
	if serialized is Dictionary:
		for p: String in serialized:
			if _CALLABLES.has(p):
				var callable: Callable = _CALLABLES.get(p) as Callable
				var result: Variant = callable.call(serialized[p])
				return result
	
	return serialized
	
	#if deserialized is Dictionary:
		#var packet: Dictionary = deserialized
		#if packet.has("v"):
			#var value: Variant = packet.get("v")
			#
			#var type: int = typeof(value)
			#match type:
				#TYPE_DICTIONARY:
					#return _parse_dictionary(value)
				#TYPE_ARRAY:
					#return _parse_array(value)
			#
			#return value
		#
		#if packet.has("cn"):
			#var cached_id: int = packet.get("cn", -1) as int
			#var path: String = SD_Array.get_value_from_array(_singleton.get_cached_nodes(), cached_id, "")
			#return SimusDev.get_node_or_null(path)
		#
		#if packet.has("o"):
			#return _parse_object(packet["o"])
		#
		#if packet.has("r"):
			#return _parse_resource(packet["r"])
		#
	#return deserialized

static func _parse_resource(dict: Dictionary) -> Variant:
	if dict.has("l"):
		return str_to_var(dict["l"])
	return load(dict["p"])
