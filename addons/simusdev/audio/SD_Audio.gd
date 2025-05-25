extends SD_Object
class_name SD_Audio

static var trunk: SD_TrunkAudio

static func get_bus_by_name(name: String) -> SD_AudioBus:
	return trunk.get_bus_by_name(name)

static func get_bus_by_id(id: int) -> SD_AudioBus:
	return trunk.get_bus_by_id(id)
