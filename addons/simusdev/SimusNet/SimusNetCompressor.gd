@static_unload
extends RefCounted
class_name SimusNetCompressor

static func parse_gzip(variant: Variant) -> PackedByteArray:
	return parse(variant, FileAccess.COMPRESSION_GZIP)

static func parse(variant: Variant, mode: FileAccess.CompressionMode = FileAccess.CompressionMode.COMPRESSION_DEFLATE) -> PackedByteArray:
	var bytes: PackedByteArray = var_to_bytes(variant)
	var compressed: PackedByteArray = bytes.compress(mode)
	return compressed
