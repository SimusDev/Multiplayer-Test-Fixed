@icon("res://addons/simusdev/components/fp_controller/source_like/icon.png")
extends Node3D
class_name W_FPCSourceLike

@export var multiplayer_authorative: bool = true
@export var enabled: bool = true : set = set_enabled_status, get = get_enabled_status

signal enabled_status_changed(status: bool)

@onready var console := SimusDev.console

var _disable_priority: int = 0

func is_authority() -> bool:
	if multiplayer_authorative:
		return is_multiplayer_authority()
	return true

func _enter_tree() -> void:
	_enabled_status_changed()

func set_enabled_status(status: bool) -> void:
	enabled = status
	enabled_status_changed.emit(enabled)
	_enabled_status_changed()

func _enabled_status_changed() -> void:
	pass

func is_enabled() -> bool:
	return enabled

func is_disabled() -> bool:
	return !is_enabled()

func get_disable_priority() -> int:
	return _disable_priority

func add_disable_priority() -> void:
	set_disable_priority(get_disable_priority() + 1)

func subtract_disable_priority() -> void:
	set_disable_priority(get_disable_priority() - 1)

func set_disable_priority(value: int) -> void:
	_disable_priority = value
	enabled = _disable_priority <= 0


func get_enabled_status() -> bool:
	return enabled 

static func normalize_mouse_sensitivity(sens: float) -> float:
	return sens * 0.1
