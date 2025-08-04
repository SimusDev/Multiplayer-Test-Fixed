extends S_EventDeath
class_name S_EventDeathLocal

var playable: SourcePlayable

static func as_event() -> S_EventDeathLocal:
	return SourceEvents.get_by_script(S_EventDeathLocal) as S_EventDeathLocal

func setup_local(source: Node, health: SourceHealth, playable: SourcePlayable) -> S_EventDeathLocal:
	self.source = source
	self.health = health
	self.playable = playable
	return self
