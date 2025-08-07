@static_unload
extends SD_Object
class_name SD_Variables

static func variant_to_string(variant: Variant) -> String:
	return var_to_str(variant)

static func string_to_variant(string: String, default_value: Variant = null) -> Variant:
	var parsed: Variant = str_to_var(string)
	if parsed == null:
		return default_value
	return parsed

static var __instantiate_class_script: String = "
extends RefCounted

func instantiate(name: String) -> Variant:
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
