@tool
extends Area3D
class_name SourceHurtbox

@export var damage: float = 10.0

signal damaged(hitbox: SourceHitbox)

func _ready() -> void:
	monitorable = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(SourceHitbox.HITBOX_LAYER, true)
	set_collision_mask_value(SourceHitbox.HITBOX_LAYER, true)
	
	if Engine.is_editor_hint():
		return
	
	if not SD_Network.is_server():
		queue_free()
		return
	
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is SourceHitbox:
		area.apply_damage(damage)
		damaged.emit(area)
