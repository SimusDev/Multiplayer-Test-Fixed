extends S_EventObject
class_name S_EventObjectDeleted

static func as_event() -> S_EventObjectDeleted:
	return SourceEvents.get_by_script(S_EventObjectDeleted)
