extends Node
class_name S_NabludatorWeapons

func _ready() -> void:
	NabludatorEvents.i.event_shoot.connect(_on_event_shoot)

func _on_event_shoot(actions: C_NabludatorItemActionsWeapon, shooter: Node3D) -> void:
	if not SD_Network.is_server():
		return
	
	var eyes_reference: C_NabludatorEyesRayCastReference = C_NabludatorEyesRayCastReference.find_in(shooter)
	if !eyes_reference:
		return
	
	var raycast: RayCast3D = eyes_reference.raycast
	
	var object: Object = raycast.get_collider()
	if object is C_NabludatorHitbox:
		object.apply_damage(actions.weapon.base_damage, shooter)
