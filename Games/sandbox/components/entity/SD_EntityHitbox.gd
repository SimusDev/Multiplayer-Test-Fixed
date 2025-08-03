@tool
extends Area3D
class_name SB_EntityHitbox

const COLLISION_LAYER: int = 2

@export var health: SB_EntityHealth
@export var damage_multiplier: float = 1.0

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	if not SD_Network.is_server():
		process_mode = Node.PROCESS_MODE_DISABLED
		set_process(false)
		set_physics_process(false)
		queue_free()
		return
	

func _ready() -> void:
	if not Engine.is_editor_hint():
		if not SD_Network.is_server():
			return
	
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(COLLISION_LAYER, true)
	set_collision_mask_value(COLLISION_LAYER, true)
	
	if Engine.is_editor_hint():
		return
	
	if not health:
		_try_find_health(self)

func _try_find_health(from: Node) -> void:
	var hp: SB_EntityHealth = SB_EntityHealth.find_in(from)
	if hp:
		health = hp
		return
	
	_try_find_health(from.get_parent())

func apply_damage(points: float) -> void:
	health.apply_damage(points * damage_multiplier)
