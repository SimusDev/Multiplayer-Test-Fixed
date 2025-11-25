extends Node
class_name SD_NetTrunk

var singleton: SD_NetworkSingleton
var console: SD_TrunkConsole

func _ready() -> void:
	singleton = get_parent() as SD_NetworkSingleton
	console = SimusDev.console
	
	await singleton.initialized
	singleton.on_connected_to_server.connect(_connected_to_the_server)
	singleton.register_object(self, false)
	_initialized()
	

func _connected_to_the_server() -> void:
	pass

func _initialized() -> void:
	pass
