extends S_Event
class_name S_EventImpact

var source: Node
var player: Node3D
var collider: Object

func try_get_hitbox() -> SourceHitbox:
	if collider is SourceHitbox:
		return collider
	return null

func try_get_prop() -> SourceProp:
	if collider is SourceProp:
		return collider
	return null
