extends Area3D
class_name W_ComponentZone3D

@export var enabled: bool = true
signal hitbox_entered(hitbox: W_ComponentHitbox3D)
signal hitbox_exited(hitbox: W_ComponentHitbox3D)

var _overlapping_hitboxes: Array[W_ComponentHitbox3D] = []

func _init() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area3D) -> void:
	if not enabled:
		return
	
	if area is W_ComponentHitbox3D:
		_overlapping_hitboxes.append(area)
		hitbox_entered.emit(area)


func _on_area_exited(area: Area3D) -> void:
	if not enabled:
		return
	
	if area is W_ComponentHitbox3D:
		_overlapping_hitboxes.erase(area)
		hitbox_exited.emit(area)


func get_overlapping_hitboxes() -> Array[W_ComponentHitbox3D]:
	return _overlapping_hitboxes
