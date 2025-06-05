@tool
extends Node
class_name SD_NetTrunk

var singleton: SD_NetworkSingleton

var console: SD_TrunkConsole = SimusDev.console

func init(singleton: SD_NetworkSingleton) -> void:
	self.singleton = singleton
	_begin_init()
	var script: Script = get_script()
	if script is Script:
		var global_class: String = script.get_global_name()
		name = global_class.validate_node_name()
		console.write_info("Network Trunk initialized: %s" % global_class)
	
	_post_init()

func _begin_init() -> void:
	pass

func _post_init() -> void:
	pass
