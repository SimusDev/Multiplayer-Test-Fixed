@icon("res://addons/simusdev/icons/Resource.svg")
extends Control
class_name SD_ControlBasedComponent

@export var multiplayer_authorative: bool = false
@export var _active: bool = true : set = set_active, get = is_active
@export var _disable_priority: int : set = set_disable_priority, get = get_disable_priority

signal active_status_changed()
signal disable_priority_changed()

func is_authority() -> bool:
	if multiplayer_authorative:
		return SD_Network.is_authority(self)
	return true

func set_active(value: bool) -> void:
	if _active == value:
		return
	
	_active = value
	_update_active_status()
	active_status_changed.emit()
	
	if is_active():
		_on_enabled()
	else:
		_on_disabled()

func set_disable_priority(value: int) -> void:
	if _disable_priority == value:
		return
	
	_disable_priority = value
	disable_priority_changed.emit()
	
	set_active(_disable_priority <= 0)
	
	_update_active_status()

func get_disable_priority() -> int:
	return _disable_priority

func is_active() -> bool:
	return _active

func _enter_tree() -> void:
	_update_active_status()
	
	if is_active():
		_on_enabled()

func _exit_tree() -> void:
	_update_active_status()
	_on_disabled()

func add_disable_priority() -> void:
	_disable_priority += 1

func subtract_disable_priority() -> void:
	_disable_priority -= 1

func _update_active_status() -> void:
	var active: bool = is_active() and is_authority()
	set_process(active)
	set_physics_process(active)
	set_process_input(active)
	set_process_unhandled_input(active)
	set_process_unhandled_key_input(active)

func _on_enabled() -> void:
	pass

func _on_disabled() -> void:
	pass
