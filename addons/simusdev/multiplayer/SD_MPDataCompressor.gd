@static_unload
extends Object
class_name SD_MPDataCompressor

const DEFAULT_MODE: int = FileAccess.COMPRESSION_GZIP
const MIN_BYTES_TO_COMPRESS: int = 250

static func try_compress(data: Variant, mode: int = DEFAULT_MODE) -> PackedByteArray:
	var bytes: PackedByteArray = var_to_bytes(data)
	if bytes.size() < MIN_BYTES_TO_COMPRESS:
		return PackedByteArray()
	return compress(data, mode, bytes)

static func compress(data: Variant, mode: int = DEFAULT_MODE, _bytes: PackedByteArray = []) -> PackedByteArray:
	var bytes: PackedByteArray = _bytes
	if bytes.is_empty():
		bytes = var_to_bytes(data)
	var compressed: PackedByteArray = bytes.compress(mode)
	return compressed

static func decompress(data: PackedByteArray, mode: int = DEFAULT_MODE) -> Variant:
	var bytes: PackedByteArray = data.decompress_dynamic(-1, mode)
	var decompressed: Variant = bytes_to_var(bytes)
	return decompressed

static func try_decompress(data: Variant, mode: int = DEFAULT_MODE) -> Variant:
	if data is PackedByteArray:
		return decompress(data, mode)
	return data

static func serialize_data(data: Variant, mode: int = DEFAULT_MODE) -> Variant:
	var str_data: String = var_to_str(data)
	var bytes: PackedByteArray = var_to_bytes(str_data)
	if bytes.size() < MIN_BYTES_TO_COMPRESS:
		return str_data
	var compressed: PackedByteArray = bytes.compress(mode)
	return compressed

static func deserialize_data(data: Variant, mode: int = DEFAULT_MODE) -> Variant:
	if data is PackedByteArray:
		var bytes: PackedByteArray = data.decompress_dynamic(-1, mode)
		var decompressed: String = str(bytes_to_var(bytes))
		var object: Variant = str_to_var(decompressed)
		return object
	return str_to_var(data)
