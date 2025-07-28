extends C_HealthComponent
class_name SB_EntityHealth

func _on_died() -> void:
	super()
	SB_EventBus.i.event_died.emit(self)

static func find_in(node: Node) -> SB_EntityHealth:
	return super(node) as SB_EntityHealth
