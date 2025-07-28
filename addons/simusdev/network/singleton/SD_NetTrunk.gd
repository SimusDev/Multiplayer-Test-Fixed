extends Node
class_name SD_NetTrunk

var singleton: SD_NetworkSingleton
var console: SD_TrunkConsole

func _ready() -> void:
	singleton = get_parent() as SD_NetworkSingleton
	console = SimusDev.console
	
	await singleton.initialized
	singleton.register_object(self)
	_initialized()

func _initialized() -> void:
	pass
