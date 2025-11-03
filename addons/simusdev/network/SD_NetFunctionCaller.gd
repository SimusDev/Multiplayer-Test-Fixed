extends Node
class_name SD_NetFunctionCaller

@export var default_channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT
@export var default_callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE

func _ready() -> void:
	SD_Network.register_channel(default_channel)

func call_func_on(peer: int, callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = default_callmode, channel: String = default_channel) -> void:
	SD_Network.call_func_on(peer, callable, args, callmode, channel)

func call_func(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = default_callmode, channel: String = default_channel) -> void:
	SD_Network.call_func(callable, args, callmode, channel)

func call_func_except_self(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = default_callmode, channel: String = default_channel) -> void:
	SD_Network.call_func_except_self(callable, args, callmode, channel)

func call_func_on_server(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = default_callmode, channel: String = default_channel) -> void:
	SD_Network.call_func_on_server(callable, args, callmode, channel)
