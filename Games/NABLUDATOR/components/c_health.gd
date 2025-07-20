extends C_HealthComponent
class_name C_NabludatorHealth

func _on_died() -> void:
	super()
	NabludatorEvents.i.event_died.emit(self)

func _enter_tree() -> void:
	target.set_meta("C_NabludatorHealth", self)

static func find_in(node: Node) -> C_NabludatorHealth:
	return super(node) as C_NabludatorHealth

static func find_nabludator(node: Node) -> C_NabludatorHealth:
	if node.has_meta("C_NabludatorHealth"):
		return node.get_meta("C_NabludatorHealth") as C_NabludatorHealth
	return null
