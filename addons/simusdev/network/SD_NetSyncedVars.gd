extends SD_Object
class_name SD_NetSyncedVars

signal synced(property: String, value: Variant)

var __list: PackedStringArray = PackedStringArray()

var __synced_list: Dictionary[String, Variant] = {}

func get_list_properties() -> PackedStringArray:
	return __list

func get_synced_dictionary() -> Dictionary[String, Variant]:
	return __synced_list

func append(property: String) -> void:
	if __list.has(property):
		return
	
	__list.append(property)

static func get_in(object: Object) -> SD_NetSyncedVars:
	if object.has_meta("_net_var_queue"):
		return object.get_meta("_net_var_queue") as SD_NetSyncedVars
	
	var queue: SD_NetSyncedVars = SD_NetSyncedVars.new()
	object.set_meta("_net_var_queue", queue)
	return queue
