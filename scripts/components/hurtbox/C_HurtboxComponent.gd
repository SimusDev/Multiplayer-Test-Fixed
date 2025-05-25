extends Area3D
class_name C_HurtboxComponent

@export var points: float = 10.0
@export var multiplier: float = 1.0

var _entered_hitboxes: Array[C_HitboxComponent]

func _ready() -> void:
	if SimusDev.multiplayerAPI.is_client():
		monitoring = false
		monitorable = false
		set_process(false)
		set_physics_process(false)
		set_physics_process_internal(false)
		set_process_internal(false)
		return
	
	area_entered.connect(_on_area_entered_)
	area_exited.connect(_on_area_exited_)

func hurt(hitbox: C_HitboxComponent) -> void:
	SimusDev.multiplayerAPI.callables.node_sync_call(hitbox, "apply_damage", [points * multiplier])

func hurt_overlapping_hitboxes() -> void:
	for hitbox in get_overlapping_hitboxes():
		hurt(hitbox)

func get_overlapping_hitboxes() -> Array[C_HitboxComponent]:
	return _entered_hitboxes

func _on_area_entered_(area: Area3D) -> void:
	if area is C_HitboxComponent:
		_entered_hitboxes.append(area)
		hurt(area)

func _on_area_exited_(area: Area3D) -> void:
	if area is C_HitboxComponent:
		_entered_hitboxes.erase(area)
