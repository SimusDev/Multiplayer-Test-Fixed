extends Node
class_name SourceEvents

static var i: SourceEvents

var _events: Dictionary[Script, S_Event] = {
	S_EventItemUse: S_EventItemUse.new(),
	S_EventWeaponMeleeImpact: S_EventWeaponMeleeImpact.new()
}

static func get_by_script(script: Script) -> S_Event:
	return get_instance()._events.get(script)

static func get_instance() -> SourceEvents:
	return i

func _enter_tree() -> void:
	i = self
