extends S_EventPlayer
class_name S_EventPlayerUICreated

var ui: SourcePlayerUI

static func as_event() -> S_EventPlayerUICreated:
	return SourceEvents.get_by_script(S_EventPlayerUICreated)
