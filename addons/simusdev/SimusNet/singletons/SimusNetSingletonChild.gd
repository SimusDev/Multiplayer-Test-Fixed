extends Node
class_name SimusNetSingletonChild

static var singleton: SimusNetSingleton
var logger: SimusNetLogger

func initialize() -> void:
	pass

func set_multiplayer_authority(id: int, recursive: bool = true) -> void:
	super(SimusNetConnection.SERVER_ID, recursive)

func get_multiplayer_authority() -> int:
	return SimusNetConnection.SERVER_ID
