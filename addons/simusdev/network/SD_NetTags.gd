extends SD_NetworkedResource
class_name SD_NetTags

func register() -> void:
	super()

func unregister() -> void:
	super()

static func get_or_create(object: Object) -> SD_NetTags:
	if SD_Network.is_object_registered(object):
		return null
	
	var tags := SD_NetTags.new()
	return tags
