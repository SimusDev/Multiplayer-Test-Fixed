@tool
extends Area3D
class_name SourceHitboxArea

var _hitboxes: Array[SourceHitbox] = []

signal hitbox_entered(hitbox: SourceHitbox)
signal hitbox_exited(hitbox: SourceHitbox)

func _ready() -> void:
	if not Engine.is_editor_hint():
		if not SD_Network.is_server():
			queue_free()
			return
	
	monitoring = true
	monitorable = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(SourceHitbox.HITBOX_LAYER, true)
	set_collision_mask_value(SourceHitbox.HITBOX_LAYER, true)
	
	if Engine.is_editor_hint():
		return
	
	for area in get_overlapping_areas():
		if area is SourceHitbox:
			if not area in _hitboxes:
				_hitboxes.append(area)
	
	

func get_overlapping_hitboxes() -> Array[SourceHitbox]:
	return _hitboxes

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	if not SD_Network.is_server():
		return
	
	area_entered.connect(__on_area_entered)
	area_exited.connect(__on_area_exited)

func __on_area_entered(area: Area3D) -> void:
	if area is SourceHitbox:
		_hitboxes.append(area)
		hitbox_entered.emit(area)

func __on_area_exited(area: Area3D) -> void:
	if area is SourceHitbox:
		_hitboxes.erase(area)
		hitbox_exited.emit(area)
