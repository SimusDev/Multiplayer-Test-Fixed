extends Resource
class_name SourceAttribute

func _init() -> void:
	SD_Network.singleton.cache.cache_resource(self)

static func find_from_array(array: Array[SourceAttribute], script: Script) -> SourceAttribute:
	var result: SourceAttribute
	for i in array:
		if SD_Components.get_base_script(i.get_script()) == script:
			result = i
	return result
