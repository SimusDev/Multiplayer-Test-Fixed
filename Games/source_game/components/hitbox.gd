@tool
class_name SourceHitbox extends Area3D

@export var health:C_HealthComponent

@export var damage_multiplier: float = 1.0

const HITBOX_LAYER: int = 2

func _ready() -> void:
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(HITBOX_LAYER, true)
	set_collision_mask_value(HITBOX_LAYER, true)
	
	if Engine.is_editor_hint():
		return
	
	if not SD_Network.is_server():
		queue_free()
		return

func apply_damage(points: float) -> void:
	health.apply_damage(points * damage_multiplier)
