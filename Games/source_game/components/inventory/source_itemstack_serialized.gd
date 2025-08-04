extends Resource
class_name SourceItemStackSerialized

var _data: Dictionary = {} 

static func serialize(from: SourceItemStack) -> SourceItemStackSerialized:
	var serialized := SourceItemStackSerialized.new()
	serialized._data = from.serialize()
	return serialized

static func serialize_from_object(object: R_SourceWorldObject) -> SourceItemStackSerialized:
	var item := SourceItemStack.create(object)
	var serialized: SourceItemStackSerialized = serialize(item)
	SD_Nodes.fast_queue_free(item)
	return serialized

func deserialize() -> SourceItemStack:
	return SourceItemStack.deserialize(_data)
