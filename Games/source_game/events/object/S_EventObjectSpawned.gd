extends S_EventObject
class_name S_EventObjectSpawned

static func as_event() -> S_EventObjectSpawned:
	return SourceEvents.get_by_script(S_EventObjectSpawned)
