extends SD_Event
class_name S_Event

static var _events: SourceEvents

static func get_by_script(script: Script) -> S_Event:
	return _events.get_by_script(script)
