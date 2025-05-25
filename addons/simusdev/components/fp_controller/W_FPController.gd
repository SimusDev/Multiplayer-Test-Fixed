extends Node3D
class_name W_FPController

@export var character_component: W_ComponentCharacterBody3D
@export var enabled: bool = true : set = set_enabled_status, get = get_enabled_status

signal enabled_status_changed(status: bool)

@onready var console := SimusDev.console

func set_enabled_status(status: bool) -> void:
	enabled = status
	enabled_status_changed.emit(enabled)

func get_enabled_status() -> bool:
	return enabled 

static func get_normalized_mouse_sensitivity(sens: float) -> float:
	return sens * 0.15
