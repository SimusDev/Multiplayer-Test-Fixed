extends S_Event
class_name S_EventDeath

var source: Node
var health: SourceHealth

static func as_event() -> S_EventDeath:
	return SourceEvents.get_by_script(S_EventDeath) as S_EventDeath

func setup(source: Node, health: SourceHealth) -> S_EventDeath:
	self.source = source
	self.health = health
	return self
