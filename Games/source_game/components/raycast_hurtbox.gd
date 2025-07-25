@tool
extends RayCast3D
class_name SourceRaycastHurtbox

@export var damage: float = 10.0
@export var oneshot: bool = true

signal damaged(hitbox: SourceHitbox)

func _ready() -> void:
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(SourceHitbox.HITBOX_LAYER, true)
	
	if Engine.is_editor_hint():
		return
	
	if not SD_Network.is_server():
		queue_free()
		return
	

func _physics_process(delta: float) -> void:
	for i in get_collider():
		if i is SourceHitbox:
			i.apply_damage(damage)
			damaged.emit(i)
			if oneshot:
				_physics_process(false)
