extends S_EventObject
class_name S_EventObjectDespawned

static func as_event() -> S_EventObjectDespawned:
	return SourceEvents.get_by_script(S_EventObjectDespawned)
