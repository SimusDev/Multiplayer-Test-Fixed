extends Area3D
class_name C_HitboxComponent

@export var health: C_HealthComponent

@export var damage_multiplier: float = 1.0

func _ready() -> void:
	if SimusDev.multiplayerAPI.is_client():
		monitoring = false
		monitorable = false
		hide()
		set_process(false)
		set_physics_process(false)
		return


func apply_damage(points: float) -> void:
	health.apply_damage(points * damage_multiplier)
