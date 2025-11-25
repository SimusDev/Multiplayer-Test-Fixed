extends SD_NetSync
class_name SD_NetSyncedBase

@export var node_path: NodePath
@export var channels: Array[String] = [SD_NetTrunkCallables.CHANNEL_DEFAULT]

enum SYNC_MODE {
	ALWAYS,
	ON_CHANGE,
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

@export var tickrate: float = DEFAULT_TICKRATE
@export var tickrate_mode: TICKRATE_MODE
@export var sync_mode: SYNC_MODE = SYNC_MODE.ON_CHANGE
@export var sync: SYNC = SYNC.FROM_SERVER
@export var callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.UNRELIABLE

func get_tickrate_in_seconds() -> float:
	return float(1.0) / tickrate
