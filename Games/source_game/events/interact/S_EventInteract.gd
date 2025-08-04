extends S_Event
class_name S_EventInteract

var ray: SourceInteractRay
var source: Node
var player: SourcePlayer
var object: Object

static func as_event() -> S_EventInteract:
	return SourceEvents.get_by_script(S_EventInteract)
