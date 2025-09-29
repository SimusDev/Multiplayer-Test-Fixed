extends S_EventPlayer
class_name S_EventPlayerSpawned

static func as_event() -> S_EventPlayerSpawned:
	return SourceEvents.get_by_script(S_EventPlayerSpawned)
