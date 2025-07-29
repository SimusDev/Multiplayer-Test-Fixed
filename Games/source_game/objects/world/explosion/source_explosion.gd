extends Node3D
class_name SourceExplosion

@export var _area: SourceHitboxArea

@export var damage: float = 100.0
@export var size: float = 1.0

@export var explode_at_start: bool = true

var _exploded: bool = false

var _waiting_for_explode: bool = true

func set_damage(points: float) -> SourceExplosion:
	damage = points
	return self

func set_size(value: float) -> SourceExplosion:
	size = value
	return self

static func create() -> SourceExplosion:
	var obj := R_SourceWorldObject.get_by_id("world.explosion")
	var obj_ref := obj.create()
	var src: SourceExplosion = obj_ref.source
	src.explode_at_start = false
	obj_ref.instantiate()
	return src

static func create_at(node: Node) -> SourceExplosion:
	var src := create()
	if node is Node3D:
		src.global_position = node.global_position
	return src

func _ready() -> void:
	if not SD_Network.is_server():
		hide()
		process_mode = Node.PROCESS_MODE_DISABLED
		set_process(false)
		return
	
	if explode_at_start:
		explode()

func _process(delta: float) -> void:
	if _waiting_for_explode:
		if not _area.get_overlapping_hitboxes().is_empty():
			explode()

func explode() -> void:
	if not SD_Network.is_server() or _exploded:
		return
	
	if _area.get_overlapping_hitboxes().is_empty() and not _waiting_for_explode:
		_waiting_for_explode = true
		return
	
	_area.scale = Vector3(size, size, size)
	
	var event_pre: S_EventExplosionPre = S_EventExplosionPre.get_by_script(S_EventExplosionPre) as S_EventExplosionPre
	event_pre.explosion = self
	if !event_pre.publish():
		return
	
	var healths: Dictionary[C_HealthComponent, float] = {}
	for hitbox in _area.get_overlapping_hitboxes():
		if hitbox.health in healths:
			continue
		
		var damage_multiplier: float = 1.0
		
		healths[hitbox.health] = damage_multiplier
	
	for hp in healths:
		#print(damage * healths[hp])
		hp.apply_damage(damage * healths[hp])
	
	var event_after: S_EventExplosionAfter = S_EventExplosionAfter.get_by_script(S_EventExplosionAfter) as S_EventExplosionAfter
	event_after.explosion = self
	event_after.publish()
	
	#queue_free()
	_exploded = true
	queue_free()
