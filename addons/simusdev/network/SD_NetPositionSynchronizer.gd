extends Node
class_name SD_NetPositionSynchronizer

@export var interpolation: bool = true
@export var synchronize: Dictionary[StringName, bool] = {
	"position": true,
	"scale": true,
	"rotation": true,
}

@export var channel: StringName = "position"
@export var tickrate: float = 32.0
@export var callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.UNRELIABLE

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_channel(channel)
	SD_Network.register_functions([
		
	])
	
	
	for p in synchronize:
		synchronize_property(p)

func synchronize_property(p_name: StringName) -> void:
	pass
