extends S_EventObject
class_name S_EventObjectCreated

static func as_event() -> S_EventObjectCreated:
	return SourceEvents.get_by_script(S_EventObjectCreated)
