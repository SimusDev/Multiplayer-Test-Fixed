extends SD_MPPSSyncedBase
class_name SD_MPPSSyncedProperty

enum SYNC_MODE {
	ALWAYS,
	ON_CHANGE,
	DISABLED,
}

enum TICKRATE_MODE {
	PHYSICS,
	IDLE,
	DISABLED,
}

@export var tickrate: float = 32.0
@export var tickrate_mode: TICKRATE_MODE
@export var sync_mode: SYNC_MODE
@export var properties: Array[String] 
@export var sync_at_start: bool = true
@export var interpolation_enabled: bool = false
@export var interpolation_speed: float = 30.0

func get_tickrate_in_seconds() -> float:
	return float(1.0) / tickrate
