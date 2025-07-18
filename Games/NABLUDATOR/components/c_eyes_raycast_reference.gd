extends Node
class_name C_NabludatorEyesRayCastReference

@export var root: Node3D
@export var raycast: RayCast3D

func _enter_tree() -> void:
	root.set_meta("C_NabludatorEyesRayCastReference", self)

static func find_in(node: Node) -> C_NabludatorEyesRayCastReference:
	return node.get_meta("C_NabludatorEyesRayCastReference", null)
