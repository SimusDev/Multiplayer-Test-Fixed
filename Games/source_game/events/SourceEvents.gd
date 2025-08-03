extends Node
class_name SourceEvents

static var i: SourceEvents

var _events: Dictionary[Script, S_Event] = {
	S_EventItemUse: S_EventItemUse.new(),
	S_EventWeaponMeleeImpact: S_EventWeaponMeleeImpact.new(),
	S_EventGunFire: S_EventGunFire.new(),
	S_EventGunFirePre: S_EventGunFirePre.new(),
	S_EventExplosionAfter: S_EventExplosionAfter.new(),
	S_EventExplosionPre: S_EventExplosionPre.new(),
	S_EventExplosionParticlesCreated: S_EventExplosionParticlesCreated.new()
}

static func get_by_script(script: Script) -> S_Event:
	return get_instance()._events.get(script)

static func get_instance() -> SourceEvents:
	return i

func _enter_tree() -> void:
	S_Event._events = self
	i = self
