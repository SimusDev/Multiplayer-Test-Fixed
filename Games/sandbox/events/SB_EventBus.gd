extends Node
class_name SB_EventBus

static var i: SB_EventBus

signal event_died(health: SB_EntityHealth)

func _init() -> void:
	i = self
