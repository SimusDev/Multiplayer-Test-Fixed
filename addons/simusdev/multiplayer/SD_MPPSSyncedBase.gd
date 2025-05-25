extends Resource
class_name SD_MPPSSyncedBase

enum MODE {
	FROM_SERVER,
	AUTHORITY,
}

@export var node_path: NodePath
@export var reliable: bool = false
@export var mode: MODE
