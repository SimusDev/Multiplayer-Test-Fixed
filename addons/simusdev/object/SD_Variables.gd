@tool
@static_unload
extends SD_Object
class_name SD_Variables

static var _stream_peer_buffer: StreamPeerBuffer = StreamPeerBuffer.new()

static func serialize_unsigned_int(integer: Variant) -> Variant:
	if integer is int:
		_stream_peer_buffer.clear()
		if integer <= 255:
			_stream_peer_buffer.put_u8(integer)
			return _stream_peer_buffer.data_array
			
		if integer <= 65_535:
			_stream_peer_buffer.put_u16(integer)
			return _stream_peer_buffer.data_array
			
		if integer <= 4_294_967_295:
			_stream_peer_buffer.put_u32(integer)
			return _stream_peer_buffer.data_array
			
		if integer <= 18_446_744_073_709_554_61:
			_stream_peer_buffer.put_u64(integer)
			return _stream_peer_buffer.data_array
	
	
	
	return integer

static func deserialize_unsigned_int(integer: Variant) -> Variant:
	if integer is PackedByteArray:
		_stream_peer_buffer.data_array = integer
		match integer.size():
			1:
				return _stream_peer_buffer.get_u8()
			2:
				return _stream_peer_buffer.get_u16()
			4:
				return _stream_peer_buffer.get_u32()
			8:
				return _stream_peer_buffer.get_u64()
	return integer

static func variant_to_string(variant: Variant) -> String:
	return var_to_str(variant)

static func string_to_variant(string: String, default_value: Variant = null) -> Variant:
	var parsed: Variant = str_to_var(string)
	if parsed == null:
		return default_value
	return parsed

static var __instantiate_class_script: String = "
extends RefCounted

func instantiate(_name: String) -> Variant:
	return %s.new()

"

static func instantiate_class(name: String) -> Variant:
	var __class_instantiator: RefCounted = RefCounted.new()
	var script: GDScript = GDScript.new()
	script.source_code = __instantiate_class_script % [name]
	script.reload()
	__class_instantiator.set_script(script)
	return __class_instantiator.instantiate(name)

static func get_class_from(object: Object) -> String:
	var script: Script = object.get_script() as Script
	if script:
		if script is Script:
			return script.get_global_name()
	return object.get_class()

static func compress_gzip(variant: Variant) -> PackedByteArray:
	return compress(variant, FileAccess.COMPRESSION_GZIP)

static func decompress_gzip(bytes: PackedByteArray, mode: FileAccess.CompressionMode = FileAccess.CompressionMode.COMPRESSION_DEFLATE) -> Variant:
	return decompress(bytes, FileAccess.COMPRESSION_GZIP)

static func compress(variant: Variant, mode: FileAccess.CompressionMode = FileAccess.CompressionMode.COMPRESSION_DEFLATE) -> PackedByteArray:
	var bytes: PackedByteArray = var_to_bytes(variant)
	var compressed: PackedByteArray = bytes.compress(mode)
	return compressed

static func decompress(bytes: PackedByteArray, mode: FileAccess.CompressionMode = FileAccess.CompressionMode.COMPRESSION_DEFLATE) -> Variant:
	return bytes_to_var(bytes.decompress_dynamic(-1, mode))

static func get_object_meta(object: Object, meta: StringName, default: Variant = null) -> Variant:
	if object.has_meta(meta):
		return object.get_meta(meta)
	return default

static func get_or_add_object_meta(object: Object, meta: StringName, default: Variant = null) -> Variant:
	if object.has_meta(meta):
		return object.get_meta(meta)
	
	object.set_meta(meta, default)
	print(object)
	return default

static func set_object_meta(object: Object, meta: StringName, value: Variant) -> void:
	object.set_meta(meta, value)
