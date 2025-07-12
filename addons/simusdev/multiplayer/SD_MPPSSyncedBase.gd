extends Resource
class_name SD_MPPSSyncedBase

#enum MODE {
	#FROM_SERVER,
	#AUTHORITY,
#}

@export var node_path: NodePath
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

enum SYNC {
	AUTHORITY,
	FROM_SERVER,
}



@export var tickrate: float = 32.0
@export var tickrate_mode: TICKRATE_MODE
@export var sync_mode: SYNC_MODE = SYNC_MODE.ON_CHANGE
@export var sync: SYNC = SYNC.AUTHORITY
@export var callmode: SD_Multiplayer.CALLMODE = SD_Multiplayer.CALLMODE.UNRELIABLE

func get_tickrate_in_seconds() -> float:
	return float(1.0) / tickrate
