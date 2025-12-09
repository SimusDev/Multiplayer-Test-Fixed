extends RefCounted
class_name SD_NetworkFunctionCaller

var channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT
var callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE

func _init(channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE) -> void:
	self.channel = channel
	self.callmode = callmode
	SD_Network.register_channel(channel)

func call_func_on(peer: int, callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = callmode, channel: String = channel) -> void:
	SD_Network.call_func_on(peer, callable, args, callmode, channel)

func call_func(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = callmode, channel: String = channel) -> void:
	SD_Network.call_func(callable, args, callmode, channel)

func call_func_except_self(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = callmode, channel: String = channel) -> void:
	SD_Network.call_func_except_self(callable, args, callmode, channel)

func call_func_on_server(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = callmode, channel: String = channel) -> void:
	SD_Network.call_func_on_server(callable, args, callmode, channel)
