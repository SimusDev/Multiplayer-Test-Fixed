extends Area3D
class_name C_NabludatorHitbox

@export var root: Node3D
@export var health: C_HealthComponent

@export var damage_multiplier: float = 1.0

func _ready() -> void:
	if not SD_Multiplayer.is_server():
		queue_free()
		return
	
	if !root:
		root = get_parent()
	
	if !health:
		health = C_NabludatorHealth.find_nabludator(root)

func apply_damage(points: float, source: Object = null) -> void:
	health.damage_source = source
	health.apply_damage(points * damage_multiplier)
