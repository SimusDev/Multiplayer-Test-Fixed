extends Resource
class_name SD_MPPSSyncedBase

#enum MODE {
	#FROM_SERVER,
	#AUTHORITY,
#}

@export var node_path: NodePath
@export var reliable: bool = false
#@export var mode: MODE

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
@export var sync_mode: SYNC_MODE = SYNC_MODE.ON_CHANGE

func get_tickrate_in_seconds() -> float:
	return float(1.0) / tickrate
