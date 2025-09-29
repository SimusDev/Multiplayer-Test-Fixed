extends S_EventPlayer
class_name S_EventPlayerDespawned

static func as_event() -> S_EventPlayerDespawned:
	return SourceEvents.get_by_script(S_EventPlayerDespawned)
