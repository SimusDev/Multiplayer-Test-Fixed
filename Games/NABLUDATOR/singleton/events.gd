extends Node
class_name NabludatorEvents

signal event_shoot(actions: C_NabludatorItemActionsWeapon, shooter: Node3D)

static var i: NabludatorEvents

static func get_instance() -> NabludatorEvents:
	return i

func _enter_tree() -> void:
	i = self
