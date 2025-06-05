extends SD_NetTrunk
class_name SD_NetTrunkPackets

var _cached_resources: Array[String] = []

var TYPEOF_SERIALIZE_CALLBACKS: Dictionary[int, Callable] = {
	TYPE_ARRAY : _serialize_array,
	TYPE_DICTIONARY : _serialize_dictionary,
	TYPE_OBJECT : _serialize_object,
}

enum PACKET_KEY {
	VALUE,
}

func _serialize_array(array: Array) -> void:
	pass

func _serialize_dictionary(dictionary: Dictionary) -> void:
	pass

func _serialize_object(object: Object) -> void:
	pass

func serialize_var(variant: Variant, _owner: Object = null) -> PackedByteArray:
	var packet: Dictionary[int, Variant] = {}
	
	var bytes: PackedByteArray = var_to_bytes(packet)
	return bytes

func deserialize_var(bytes: PackedByteArray) -> Variant:
	var variant: Variant = null
	
	return variant
