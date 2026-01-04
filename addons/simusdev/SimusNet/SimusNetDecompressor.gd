@static_unload
extends RefCounted
class_name SimusNetDecompressor

static func parse_gzip(bytes: PackedByteArray, mode: FileAccess.CompressionMode = FileAccess.CompressionMode.COMPRESSION_DEFLATE) -> Variant:
	return parse(bytes, FileAccess.COMPRESSION_GZIP)

static func parse(bytes: PackedByteArray, mode: FileAccess.CompressionMode = FileAccess.CompressionMode.COMPRESSION_DEFLATE) -> Variant:
	return bytes_to_var(bytes.decompress_dynamic(-1, mode))
