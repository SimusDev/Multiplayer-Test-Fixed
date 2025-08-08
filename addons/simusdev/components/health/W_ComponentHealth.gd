@tool
@icon("res://Games/source_game/components/icons/health.png")
extends Node
class_name W_ComponentHealth

signal died()
signal health_changed()
signal max_health_changed()

@export var enabled: bool = true
@export var target: Node
@export var destroy_target_on_death: bool = false
@export var god_mode: bool = false
@export var health: float = 100.0 : set = set_health, get = get_health
@export var max_health: float = 100.0 : set = set_max_health, get = get_max_health

var _last_health: float = 100.0

var _died: bool = false

func get_last_health() -> int:
	return _last_health

func kill() -> void:
	set_health(0)

func set_health(points: float) -> void:
	if not enabled:
		return
	
	if points == health:
		return
	
	if points > 0:
		_died = false
	
	_last_health = health
	health = points
	health = clamp(health, 0.0, max_health)
	__on_health_changed_()
	

func set_max_health(points: float) -> void:
	if not enabled:
		return
	
	if max_health == points:
		return
	
	max_health = points
	
	if Engine.is_editor_hint():
		health = max_health
	
	max_health_changed.emit(max_health)

func apply_damage(points: float) -> void:
	if god_mode:
		return
	
	health -= points

func heal(points: float) -> void:
	health += points

func get_max_health() -> float:
	return max_health

func get_health() -> float:
	return health

func is_dead() -> bool:
	return _died

func is_alive() -> bool:
	return not _died

func __on_health_changed_() -> void:
	health_changed.emit()
	
	if health <= 0.0:
		if not _died:
			died.emit()
			_on_died()
			_died = true

func _on_died() -> void:
	if destroy_target_on_death:
		if target:
			target.queue_free()

func get_parsed_string_value(value: int) -> String:
	return str(round(value))

func get_parsed_string_value_int(value: int) -> String:
	return str(int(round(value)))
